//
//  AudioFeedViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation
import UIKit

final class SongFeedViewController: UIViewController {
    
    fileprivate let tableView = UITableView()
    
    let viewModel: SongFeedViewModel
    
    init(viewModel: SongFeedViewModel) {
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
                    me.tableView.reloadData()
                }
            }
        }
        
        setupUI()
        viewModel.fetchSongs()
    }
    
    private func setupUI() {
        tableView.separatorStyle = .none
        tableView.frame = view.frame
        
        let nib = UINib(nibName: FeedCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
}

extension SongFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songsSignal.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(FeedCell.self, forIndexPath: indexPath)
    }
}

extension SongFeedViewController: UITableViewDelegate {
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

extension SongFeedViewController: FeedCellDelegate {
    func didSelectGoToPlayerButton(_ song: Song) {
        let playerVC = PlayerViewController()
        present(playerVC, animated: true, completion: nil)
    }
    
    func didSelectPlayPauseButton(_ song: Song) {
        
    }
}

