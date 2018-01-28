//
//  FeedCell.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation
import UIKit

protocol FeedCellDelegate: class {
    func didSelectGoToPlayerButton(_ cell: FeedCell, song: Song)
    func didSelectPlayPauseButton(_ cell: FeedCell, song: Song, at index: Int)
}

final class FeedCell: UITableViewCell {
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel2: UILabel!
    
    var song: Song? {
        didSet {
            guard let song = song else { return }
            
            songNameLabel.text = song.name
            authorNameLabel.text = song.author.name
            authorNameLabel2.text = song.author.name
            songImageView.loadImage(url: song.picture.large)
            authorImageView.loadImage(url: song.author.picture.small)
            
            switchPlayPauseButtonImage(isPlaying: song.isPlaying)
            durationLabel.isHidden = !song.isPlaying
        }
    }
    
    var row = 0
    
    weak var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        authorImageView.roundCircle()
    }
    
    func switchPlayPauseButtonImage(isPlaying: Bool) {
        let image = isPlaying ? #imageLiteral(resourceName: "ic_pause_rounded") : #imageLiteral(resourceName: "ic_play_rounded")
        playPauseButton.setImage(image, for: .normal)
    }
    
    func showDuration(currentTime: TimeInterval, duration: TimeInterval) {
        durationLabel.isHidden = false
        durationLabel.text = "\(currentTime.toTime()) / \(duration.toTime())"
    }
    
    @IBAction func goToPlayerButtonTapped(_ sender: UIButton) {
        guard let song = song else { return }
        delegate?.didSelectGoToPlayerButton(self, song: song)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        guard let song = song else { return }
        delegate?.didSelectPlayPauseButton(self, song: song, at: row)
    }
}
