//
//  AudioFeedViewModel.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation

final class FeedViewModel {
    private let networkService: NetworkService
    let playerService: PlayerService
    let songsSignal = Binding<[Song]>(value: [])
    let isPlayingSignal = Binding<Bool>(value: false)
    
    init(networkService: NetworkService, playerService: PlayerService) {
        self.networkService = networkService
        self.playerService = playerService
    }
    
    /// Fetch songs from network
    func fetchSongs() {
        networkService.fetchSongs() { [weak self] (result) in
            switch result {
            case .success(let songs):
                self?.songsSignal.value = songs
            case .failure(_):
                break
            }
        }
    }
}
