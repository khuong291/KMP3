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
    
    let url = URL(string: "https://gist.githubusercontent.com/anonymous/fec47e2418986b7bdb630a1772232f7d/raw/5e3e6f4dc0b94906dca8de415c585b01069af3f7/57eb7cc5e4b0bcac9f7581c8.json")!
    
    init(networkService: NetworkService, playerService: PlayerService) {
        self.networkService = networkService
        self.playerService = playerService
    }
    
    func fetchSongs() {
        networkService.fetchSongs(from: url) { [weak self] (result) in
            switch result {
            case .success(let songs):
                self?.songsSignal.value = songs
            case .failure(_):
                break
            }
        }
    }
}
