//
//  PlayerViewModel.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

final class PlayerViewModel {
    
    let playerService: PlayerService
    let songsSignal = Binding<[Song]>(value: [])
    
    init(songs: [Song], playerService: PlayerService) {
        self.songsSignal.value = songs
        self.playerService = playerService
    }
}
