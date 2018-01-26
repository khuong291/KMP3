//
//  AudioAPI.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class AudioAPI {
    static let shared = AudioAPI()
    
    func fetchAudios(from url: URL, completion: @escaping (Result<[Audio]>) -> ()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let audios = try decoder.decode([Audio].self, from: data)
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
