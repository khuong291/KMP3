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
            guard let me = self, songs.count > 0 else {
                return
            }
            
            DispatchQueue.main.async {
                me.refreshControl.endRefreshing()
                me.tableView.reloadData()
            }
        }
        
        viewModel.playerService.currentSongSignal.bind { [weak self] (song) in
            DispatchQueue.main.async {
                self?.handle(currentSong: song)
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
            miniPlayerViewController.view.heightAnchor.constraint(equalToConstant: 70),
            miniPlayerViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            miniPlayerViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            miniPlayerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        )
        
        miniPlayerViewController.didMove(toParentViewController: self)
    }
    
    @objc func refresh() {
        viewModel.fetchSongs()
    }
    
    /// Handle synchronizing playing status in each cell and mini player view
    private func handle(currentSong: Song?) {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        
        visibleIndexPaths.forEach { indexPath in
            let song = viewModel.songsSignal.value[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! FeedCell
            configurePlayingStatus(for: cell, song: song)
        }
        
        miniPlayerViewController.view.isHidden = currentSong == nil
        miniPlayerViewController.song = currentSong
        miniPlayerViewController.updatePlayPauseButtonImage(isPlaying: viewModel.playerService.isPlaying())
    }
    
    /// Configure cell playPauseButton image depend on the song stored in cell and current song
    fileprivate func configurePlayingStatus(for cell: FeedCell, song: Song) {
        guard let currentSong = viewModel.playerService.currentSongSignal.value else {
            cell.switchPlayPauseButtonImage(isPlaying: false)
            return
        }
        
        cell.switchPlayPauseButtonImage(isPlaying: song.id == currentSong.id && viewModel.playerService.isPlaying())
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
        guard let cell = cell as? FeedCell else {
            return
        }
        
        let song = viewModel.songsSignal.value[indexPath.row]
        cell.song = song
        cell.delegate = self
        configurePlayingStatus(for: cell, song: song)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width + 64
    }
}

extension FeedViewController: FeedCellDelegate {
    
    fileprivate func presentPlayerController(song: Song, playerService: PlayerService) {
        let viewModel = PlayerViewModel(songs: self.viewModel.songsSignal.value, playerService: playerService)
        let playerVC = PlayerViewController(viewModel: viewModel)
        present(playerVC, animated: true, completion: nil)
    }
    
    func didSelectGoToPlayerButton(_ cell: FeedCell, song: Song) {
        presentPlayerController(song: song, playerService: self.viewModel.playerService)
    }
    
    func didSelectPlayPauseButton(_ cell: FeedCell, song: Song) {
        viewModel.playerService.play(song: song)
    }
}

extension FeedViewController: MiniPlayerViewControllerDelegate {
    func didSelectPlayPauseButton(_ viewController: MiniPlayerViewController, song: Song) {
        viewModel.playerService.play(song: song)
    }
    
    func didSelectGoToPlayerButton(_ viewController: MiniPlayerViewController, song: Song) {
        presentPlayerController(song: song, playerService: viewModel.playerService)
    }
}

