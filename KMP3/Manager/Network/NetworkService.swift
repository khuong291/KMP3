//
//  NetworkService.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

class NetworkService {
    func fetchSongs(from url: URL, completion: @escaping (Result<[Song]>) -> ()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let audios = try decoder.decode([Song].self, from: data)
                    completion(.success(audios))
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
