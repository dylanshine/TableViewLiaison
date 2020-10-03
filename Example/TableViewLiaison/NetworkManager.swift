//
//  NetworkManager.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum NetworkManager {
    
    private static var imageCache = [String: UIImage]()
    private(set) static var factCache = [String: String]()
    private static var userCahce = [String: User]()
    private static var thumbnailCahce = [String: UIImage]()

    static func flushCache() {
        userCahce.removeAll()
        thumbnailCahce.removeAll()
        imageCache.removeAll()
        factCache.removeAll()
    }
    
    static func flushCache(for id: String) {
        imageCache[id] = nil
        factCache[id] = nil
    }
    
    private static func fetchData(from url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completion(nil) }
            
            completion(data)
        }.resume()
    }
    
    static func fetchImage(url: String,
                           completion: ((UIImage?) -> ())?) {
        
        let url = URL(string: url)!
        
        fetchData(from: url) { data in
            guard let data = data else {
                completion?(nil)
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async() {
                completion?(image)
            }
        }
    }
    
    static func fetchThumbnailImage(thumbnail: String,
                                    completion: ((UIImage?) -> ())?) {
        
        if let image = NetworkManager.thumbnailCahce[thumbnail] {
            completion?(image)
            return
        }
        
        fetchImage(url: thumbnail) { image in
            NetworkManager.thumbnailCahce[thumbnail] = image
            completion?(image)
        }
        
    }
    
    static func fetchRandomPostImage(id: String,
                                     width: Int,
                                     height: Int,
                                     completion: ((UIImage?) -> ())?) {
        
        if let image = NetworkManager.imageCache[id] {
            completion?(image)
            return
        }
        
        fetchImage(url: "https://picsum.photos/\(width)/\(height)") { image in
            NetworkManager.imageCache[id] = image
            completion?(image)
        }
        
    }
    
    static func fetchRandomFact(id: String,
                                completion: ((String?) -> ())? = nil) {
        
        if let fact = NetworkManager.factCache[id] {
            completion?(fact)
            return
        }
        
        let url = URL(string: "https://randomuselessfact.appspot.com/random.json?language=en")!
        
        fetchData(from: url) { data in
            guard let data = data else {
                completion?(nil)
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let fact = json?["text"] as? String
            
            NetworkManager.factCache[id] = fact
            
            DispatchQueue.main.async() {
                completion?(fact)
            }
        }
    }
    
    static func fetchRandomUser(id: String,
                                completion: ((User?) -> ())? = nil) {
        
        if let user = NetworkManager.userCahce[id] {
            completion?(user)
            return
        }
        
        let url = URL(string: "https://randomuser.me/api")!
        
        fetchData(from: url) { data in
            guard let data = data else {
                completion?(nil)
                return
            }
            
           let user = try? JSONDecoder().decode(User.self, from: data)

            NetworkManager.userCahce[id] = user
            
            DispatchQueue.main.async() {
                completion?(user)
            }
        }
    }
}
