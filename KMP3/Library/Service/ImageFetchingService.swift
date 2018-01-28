//
//  ImageFetchingService.swift
//  KMP3
//
//  Created by KhuongPham on 1/28/18.
//

import Foundation
import UIKit

/// Use for fetching image
final class ImageFetchingService {
    let cacheService: CacheService
    var task: URLSessionTask? // Use for download or cancel task in reusable cell
    
    init(cacheService: CacheService) {
        self.cacheService = cacheService
    }
    
    
    /// Use for fetching image from an url
    ///
    /// - Parameters:
    ///   - url: url for fetching
    ///   - completion: return an image from callback  
    func fetch(url: URL, completion: @escaping (UIImage?) -> Void) {
        task?.cancel()
        
        cacheService.loadImage(url: url, completion: { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                // If not, download image from url
                self?.task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        completion(nil)
                        return
                    }
                    
                    if let data = data {
                        self?.cacheService.save(data: data, url: url)
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                completion(image)
                            }
                        }
                    }
                })
                
                self?.task?.resume()
            }
        })
    }
}
