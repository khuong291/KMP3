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
        
        viewModel.songsSignal.bind { songs in
            print(songs)
        }
        
        setupUI()
        viewModel.fetchSongs()
    }
    
    private func setupUI() {
        tableView.separatorStyle = .none
        let nib = UINib(nibName: FeedCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        view.addSubview(tableView)
    }
}
