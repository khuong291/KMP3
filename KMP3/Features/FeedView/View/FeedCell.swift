//
//  FeedCell.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation
import UIKit

protocol FeedCellDelegate: class {
    func didSelectGoToPlayerButton(_ song: Song)
    func didSelectPlayPauseButton(_ song: Song)
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
//            songImageView.loadImage(from: song.picture.large.absoluteString)
//            authorImageView.loadImage(from: song.author.picture.small.absoluteString)
        }
    }
    
    weak var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        authorImageView.roundCircle()
    }
    
    @IBAction func goToPlayerButtonTapped(_ sender: UIButton) {
        guard let song = song else { return }
        delegate?.didSelectGoToPlayerButton(song)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        guard let song = song else { return }
        delegate?.didSelectPlayPauseButton(song)
    }
}
