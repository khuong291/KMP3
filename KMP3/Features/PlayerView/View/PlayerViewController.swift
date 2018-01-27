//
//  PlayerViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation
import UIKit

final class PlayerViewController: UIViewController {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songDurationSlider: UISlider!
    
    let viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "PlayerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        songImageView.loadImage(url: viewModel.song.picture.large)
    }
    
    @IBAction func minimizeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
