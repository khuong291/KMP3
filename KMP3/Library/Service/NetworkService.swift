//
//  NetworkService.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

struct DataHolder<T: Codable>: Codable {
    let data: T
}

class NetworkService {
    private let session: URLSession
    
    private let url = URL(string: "https://gist.githubusercontent.com/anonymous/fec47e2418986b7bdb630a1772232f7d/raw/5e3e6f4dc0b94906dca8de415c585b01069af3f7/57eb7cc5e4b0bcac9f7581c8.json")!
    
    init(config: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: config)
    }
    
    func fetchSongs(completion: @escaping (Result<[Song]>) -> ()) {
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let response = try decoder.decode(DataHolder<[Song]>.self, from: data)
                    completion(.success(response.data))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

