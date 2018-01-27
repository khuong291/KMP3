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
    let session: URLSession
    
    init(config: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: config)
    }
    
    func fetchSongs(from url: URL, completion: @escaping (Result<[Song]>) -> ()) {
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

