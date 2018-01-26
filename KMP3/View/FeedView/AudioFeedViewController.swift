//
//  AudioFeedViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation
import UIKit

final class AudioFeedViewController: UIViewController {
    
    fileprivate let tableView = UITableView()
    
    let viewModel: AudioFeedViewModel
    
    init(viewModel: AudioFeedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let mainView = UIView(frame: UIScreen.main.bounds)
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.separatorStyle = .none
        let nib = UINib(nibName: FeedCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        view.addSubview(tableView)
    }
}
