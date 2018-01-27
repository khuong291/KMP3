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
        
        viewModel.songsSignal.bind { [weak self] songs in
            if let me = self, songs.count > 0 {
                DispatchQueue.main.async {
                    me.refreshControl.endRefreshing()
                    me.tableView.reloadData()
                }
            }
        }
        
        setupUI()
        viewModel.fetchSongs()
    }
    
    private func setupUI() {
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
        cell.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width + 64
    }
}

extension FeedViewController: FeedCellDelegate {
    func didSelectGoToPlayerButton(_ song: Song) {
        let viewModel = PlayerViewModel(song: song)
        let playerVC = PlayerViewController(viewModel: viewModel)
        present(playerVC, animated: true, completion: nil)
    }
    
    func didSelectPlayPauseButton(_ song: Song) {
        viewModel.playerService.play(song: song)
    }
}

