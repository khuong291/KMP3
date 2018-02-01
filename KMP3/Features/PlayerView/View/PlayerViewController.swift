//
//  PlayerViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation
import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var songDurationSlider: UISlider!
    @IBOutlet weak var runningTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    let viewModel: PlayerViewModel
    
    private var timer: Timer!
    
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
        bind()
        
        // Use timer to update slider and time label every 1 second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
    }
    
    /// Bind current song to UI
    private func bind() {
        viewModel.playerService.currentSongSignal.bind { (song) in
            guard let _ = song else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.setupUI()
            }
        }
    }
    
    @objc func updateValue() {
        updateTime()
    }
    
    private func setupUI() {
        guard let song = viewModel.playerService.currentSongSignal.value else {
            return
        }
        
        songImageView.loadImage(url: song.picture.large)
        songNameLabel.text = song.name
        authorNameLabel.text = song.author.name
        
        updateTime()
        setupPlayPauseButtonImage()
        calculateDuration()
    }
    
    /// Switch between pause and play image depend on player is playing
    private func setupPlayPauseButtonImage() {
        let isPlaying = viewModel.playerService.isPlaying()
        let image = isPlaying ? #imageLiteral(resourceName: "ic_pause") : #imageLiteral(resourceName: "ic_player_play")
        playPauseButton.setImage(image, for: .normal)
    }
    
    /// Calculate the duration of current song
    private func calculateDuration() {
        durationLabel.text = viewModel.playerService.player.duration?.toTime()
    }
    
    /// Update running time
    private func updateTime() {
        guard let player = viewModel.playerService.player,
            viewModel.playerService.isPlaying(),
            let duration = player.duration, duration > 0 else {
            return
        }
        
        runningTimeLabel.text = player.currentTime().seconds.toTime()
        
        let currentTime = player.currentTime().seconds
        songDurationSlider.value = Float(currentTime * 1000.0 / duration)
    }
    
    /// Dismiss this controller and remove timer
    @IBAction func minimizeButtonTapped(_ sender: UIButton) {
        // Need invalidate time before dismissed
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        // remove the binding closure in viewDidLoad above to avoid memory leak
        viewModel.playerService.currentSongSignal.remove()
        dismiss(animated: true, completion: nil)
    }
    
    /// Play or pause current song and update the button image
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        guard let song = viewModel.playerService.currentSongSignal.value else {
            return
        }
        
        viewModel.playerService.play(song: song)
        setupPlayPauseButtonImage()
    }
    
    /// Play previous song
    @IBAction func playPreviousButtonTapped(_ sender: UIButton) {
        guard let currentSong = viewModel.playerService.currentSongSignal.value else {
            return
        }
        
        let songs = viewModel.songsSignal.value
        
        let currentIndex = songs.index { $0.id == currentSong.id }!
        let previousIndex = (currentIndex - 1 + songs.count) % songs.count // For play song circurlaly
        let previousSong = songs[previousIndex]
        
        let currentTime = viewModel.playerService.player.currentTime().seconds
        
        // If current song is played less than 3 seconds then play previous song
        if currentTime < 3 {
            viewModel.playerService.play(song: previousSong)
            return
        }
        // Otherwise play back again
        viewModel.playerService.play(song: currentSong, forcePlayAgain: true)
    }
    
    /// Play next song
    @IBAction func playNextButtonTapped(_ sender: UIButton) {
        guard let currentSong = viewModel.playerService.currentSongSignal.value else {
            return
        }
        
        let songs = viewModel.songsSignal.value

        let currentIndex = songs.index { $0.id == currentSong.id }!
        let nextIndex = (currentIndex + 1) % songs.count // For play song circurlaly
        let nextSong = songs[nextIndex]
        
        viewModel.playerService.play(song: nextSong)
    }
    
    /// Change current time of player
    @IBAction func changeTimeSliderAction(_ sender: UISlider) {
        guard let player = viewModel.playerService.player, sender.maximumValue > 0 else {
            return
        }
        
        let duration = player.duration ?? 0
        let time = (Double(sender.value / sender.maximumValue) * duration)
        
        viewModel.playerService.seekToTime(time)
    }
}
