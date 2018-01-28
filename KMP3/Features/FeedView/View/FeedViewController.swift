//
//  AudioFeedViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation
import UIKit

final class FeedViewController: UIViewController {
    
    fileprivate let tableView = UITableView()
    fileprivate let refreshControl = UIRefreshControl()
    
    let viewModel: FeedViewModel
    let miniPlayerViewController = MiniPlayerViewController()
    
    var previousPlayingIndex = -1
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupUI()
        viewModel.fetchSongs()
    }
    
    private func bind() {
        viewModel.songsSignal.bind { [weak self] songs in
            guard let me = self, songs.count > 0 else { return }
            
            DispatchQueue.main.async {
                me.refreshControl.endRefreshing()
                me.tableView.reloadData()
            }
        }
        
        viewModel.isPlayingSignal.bind { [weak self] (isPlaying) in
            guard let me = self else { return }
            
            DispatchQueue.main.async {
                me.miniPlayerViewController.updatePlayPauseButtonImage(isPlaying: isPlaying)
            }
        }
    }
    
    private func setupUI() {
        // Shift table over status bar
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: FeedCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        addChildViewController(miniPlayerViewController)
        view.addSubview(miniPlayerViewController.view)
        miniPlayerViewController.view.isHidden = true
        miniPlayerViewController.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        Constraint.on(
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        )
        
        Constraint.on(
            miniPlayerViewController.view.heightAnchor.constraint(equalToConstant: 50),
            miniPlayerViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            miniPlayerViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            miniPlayerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        )
        
        miniPlayerViewController.didMove(toParentViewController: self)
    }
    
    @objc func refresh() {
        viewModel.fetchSongs()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songsSignal.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(FeedCell.self, forIndexPath: indexPath)
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedCell else { return }
        
        let song = viewModel.songsSignal.value[indexPath.row]
        cell.song = song
        cell.row = indexPath.row
        cell.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width + 64
    }
}

extension FeedViewController: FeedCellDelegate {
    
    fileprivate func presentPlayerController(song: Song, playerService: PlayerService) {
        let viewModel = PlayerViewModel(song: song, playerService: playerService)
        let playerVC = PlayerViewController(viewModel: viewModel)
        present(playerVC, animated: true, completion: nil)
    }
    
    func didSelectGoToPlayerButton(_ cell: FeedCell, song: Song) {
        presentPlayerController(song: song, playerService: self.viewModel.playerService)
    }
    
    func didSelectPlayPauseButton(_ cell: FeedCell, song: Song, at index: Int) {
        // Pause if playing
        if previousPlayingIndex == index, viewModel.playerService.isPlaying() {
            viewModel.playerService.pause()
            
            cell.switchPlayPauseButtonImage(isPlaying: false)
            
            viewModel.isPlayingSignal.value = false
            return
        }
        
        // Play song
        viewModel.playerService.play(from: song.audioLink) { [weak self] isPlaying in
            guard let me = self, isPlaying else { return }
            
            // Reset all song playing states to false
            me.viewModel.songsSignal.value.forEach {
                $0.isPlaying = false
            }
    
            // Update isPlaying state on the cell selected
            let selectedSong = me.viewModel.songsSignal.value[index]
            selectedSong.isPlaying = true
            
            DispatchQueue.main.async {
                let preIndexPath = IndexPath(row: me.previousPlayingIndex, section: 0)
                // Update playing status on previous playing cell
                if let preCell = me.tableView.cellForRow(at: preIndexPath) as? FeedCell {
                    preCell.switchPlayPauseButtonImage(isPlaying: false)
                }
                
                // Update playing status on playing cell
                cell.switchPlayPauseButtonImage(isPlaying: true)
                if let player = me.viewModel.playerService.player {
                    cell.showDuration(currentTime: player.currentTime, duration: player.duration)
                }
                
                // Update miniPlayerViewController properties
                me.miniPlayerViewController.view.isHidden = false
                me.miniPlayerViewController.song = selectedSong
                
                me.viewModel.isPlayingSignal.value = true
                
                // Update previousPlayingIndex
                me.previousPlayingIndex = index
            }
        }
    }
}

extension FeedViewController: MiniPlayerViewControllerDelegate {
    func didSelectPlayPauseButton(_ viewController: MiniPlayerViewController, song: Song) {
        let indexPath = IndexPath(row: previousPlayingIndex, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? FeedCell {
            didSelectPlayPauseButton(cell, song: song, at: previousPlayingIndex)
        }
    }
    
    func didSelectGoToPlayerButton(_ viewController: MiniPlayerViewController, song: Song) {
        presentPlayerController(song: song, playerService: viewModel.playerService)
    }
}

