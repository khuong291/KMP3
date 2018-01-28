//
//  MiniPlayerViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation
import UIKit

final class MiniPlayerViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updatePlayPauseButtonImage(isPlaying: Bool) {
        let image = isPlaying ? #imageLiteral(resourceName: "ic_pause_small") : #imageLiteral(resourceName: "ic_player_play_small")
        playPauseButton.setImage(image, for: .normal)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        
    }
}
