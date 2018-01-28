//
//  PlayerViewModel.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

final class PlayerViewModel {
    
    let playerService: PlayerService
    let songSignal = Binding<Song?>(value: nil)
    
    init(song: Song, playerService: PlayerService) {
        self.songSignal.value = song
        self.playerService = playerService
    }
}
