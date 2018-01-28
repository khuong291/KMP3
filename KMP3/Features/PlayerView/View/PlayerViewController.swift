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
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var songDurationSlider: UISlider!
    @IBOutlet weak var runningTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    let viewModel: PlayerViewModel
    
    var timer: Timer!
    
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
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateValue() {
        updateTime()
    }
    
    private func setupUI() {
        guard let song = viewModel.songSignal.value else {
            return
        }
        
        songImageView.loadImage(url: song.picture.large)
        songNameLabel.text = song.name
        authorNameLabel.text = song.author.name
        
        updateTime()
        setupPlayPauseButtonImage()
        calculateDuration()
    }
    
    private func setupPlayPauseButtonImage() {
        let isPlaying = viewModel.playerService.isPlaying()
        let image = isPlaying ? #imageLiteral(resourceName: "ic_pause") : #imageLiteral(resourceName: "ic_player_play")
        playPauseButton.setImage(image, for: .normal)
    }
    
    private func calculateDuration() {
        guard let player = viewModel.playerService.player else {
            return
        }
      
        durationLabel.text = player.duration.toTime()
    }
    
    private func updateTime() {
        guard let player = viewModel.playerService.player, player.isPlaying else {
            return
        }
        
        runningTimeLabel.text = player.currentTime.toTime()
        
        songDurationSlider.value = Float(player.currentTime * 1000.0 / player.duration)
    }
    
    @IBAction func minimizeButtonTapped(_ sender: UIButton) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        
    }
}
