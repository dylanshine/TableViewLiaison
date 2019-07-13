//
//  NetworkManager.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum NetworkManager {
    
    static var imageCache = [IndexPath: UIImage]()
    static var factCache = [IndexPath: String]()

    private static func fetchData(from url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completion(nil) }
            
            completion(data)
        }.resume()
    }
    
    static func fetchImage(url: String, completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: url)!
        
        fetchData(from: url) { data in
            guard let data = data else { return completion(nil) }
   
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
    }
    
    static func fetchRandomPostImage(width: Int, height: Int, completion: @escaping (UIImage?) -> ()) {
        fetchImage(url: "https://picsum.photos/\(width)/\(height)", completion: completion)
    }
    
    static func fetchRandomFact(completion: @escaping (String?) -> ()) {
        let url = URL(string: "https://randomuselessfact.appspot.com/random.json?language=en")!
        
        fetchData(from: url) { data in
            guard let data = data else { return completion(nil) }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            DispatchQueue.main.async() {
                completion(json?["text"] as? String)
            }
        }
    }
}
