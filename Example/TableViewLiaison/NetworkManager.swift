//
//  NetworkManager.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum NetworkManager {
    
    private static var imageCache = [Int: UIImage]()
    static var factCache = [Int: String]()

    static func flushCache(for section: Int) {
        imageCache[section] = nil
        factCache[section] = nil
    }
    
    private static func fetchData(from url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completion(nil) }
            
            completion(data)
        }.resume()
    }
    
    static func fetchRandomPostImage(section: Int,
                                     width: Int,
                                     height: Int,
                                     completion: @escaping (UIImage?) -> ()) {
        
        if let image = NetworkManager.imageCache[section] {
            completion(image)
            return
        }
        
        let url = URL(string: "https://picsum.photos/\(width)/\(height)")!
        
        fetchData(from: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            NetworkManager.imageCache[section] = image
            
            DispatchQueue.main.async() {
                completion(image)
            }
        }
    }
    
    static func fetchRandomFact(section: Int,
                                completion: ((String?) -> ())? = nil) {
        
        if let fact = NetworkManager.factCache[section] {
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
            
            NetworkManager.factCache[section] = fact
            
            DispatchQueue.main.async() {
                completion?(fact)
            }
        }
    }
}
