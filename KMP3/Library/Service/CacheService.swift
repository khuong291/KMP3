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
    
    private let memory = NSCache<NSString, NSData>() // For get or load data in memory
    private let diskPath: URL // The path url that contain cached files (mp3 files and image files)
    private let fileManager: FileManager // For checking file or directory exists in a specified path
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        do {
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            diskPath = documentDirectory.appendingPathComponent("Khuong_Mp3")
            
            if !fileManager.fileExists(atPath: diskPath.path) {
                try fileManager.createDirectory(at: diskPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch {
            fatalError()
        }
    }
    
    func loadData(url: URL, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            // If object is in memory
            if let data = self.memory.object(forKey: url.absoluteString as NSString) {
                completion(data as Data)
                return
            }
            
            // If object is in disk
            if let data = try? Data(contentsOf: self.filePath(url: url)) {
                // Set back to memory
                self.memory.setObject(data as NSData, forKey: url.absoluteString as NSString)
                completion(data)
                return
            }
            
            completion(nil)
        }
    }
    
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        loadData(url: url, completion: { data in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
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
            do {
                try data.write(to: self.filePath(url: url))
            } catch {
                print(error)
            }
        }
    }
    
    /// By checking song's url, if the song was cached, then return it's cache path URL, if the song wasn't cached, then return nil
    func exists(url: URL) -> URL? {
        let fileURL = filePath(url: url)
        return fileManager.fileExists(atPath: fileURL.path) ? fileURL : nil
    }

    
    private func filePath(url: URL) -> URL {
        // Use base64 to avoid multiple splashes
        let diskURL = diskPath.appendingPathComponent(url.path.toBase64())
        // AVPlayer needs url to be of mp3 extension to play
        if url.pathExtension == "mp3" {
            return diskURL.appendingPathExtension("mp3")
        } else {
            return diskURL
        }
    }
}
