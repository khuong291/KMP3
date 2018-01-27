//
//  CacheService.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation
import UIKit

/// This service is used to manage memory and disk cache
final class CacheService {
    
    let memory = NSCache<NSString, NSData>()
    let diskPath: URL
    
    init(fileManager: FileManager = FileManager.default) {
        do {
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            self.diskPath = documentDirectory.appendingPathComponent("Khuong_Mp3")
        } catch {
            fatalError()
        }
    }
    
    func fetchData(url: URL, completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            /// If object is in memory
            if let data = self.memory.object(forKey: url.absoluteString as NSString) {
                completion(data as Data)
                return
            }
            
            /// If object is in disk
            if let data = try? Data(contentsOf: url) {
                /// Set back to memory
                self.memory.setObject(data as NSData, forKey: url.absoluteString as NSString)
                completion(data)
            }
        }
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {
        fetchData(url: url, completion: { data in
            if let image = UIImage(data: data) {
                completion(image)
            }
        })
    }
    
    /// Save image with url as key
    ///
    /// - Parameters:
    ///   - image: The image to save
    ///   - url: The url as key
    func save(image: UIImage, url: URL) {
        DispatchQueue.global().async {
            if let data = UIImagePNGRepresentation(image) {
                self.save(data: data, url: url)
            }
        }
    }
    
    
    /// Save data with url as key
    ///
    /// - Parameters:
    ///   - data: The data to save
    ///   - url: The url as key
    func save(data: Data, url: URL) {
        DispatchQueue.global().async {
            self.memory.setObject(data as NSData, forKey: url.absoluteString as NSString)
            try? data.write(to: url)
        }
    }
}
