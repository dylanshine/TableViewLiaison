//
//  User.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 5/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct User: Decodable {
    let username: String
    let thumbnail: String
    
    private enum CodingKeys: String, CodingKey {
        case results
        case login
        case username
        case picture
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var results = try container.nestedUnkeyedContainer(forKey: .results)
        let user = try results.nestedContainer(keyedBy: CodingKeys.self)
        
        username = try user.nestedContainer(keyedBy: CodingKeys.self, forKey: .login)
            .decode(String.self, forKey: .username)
        
        thumbnail = try user.nestedContainer(keyedBy: CodingKeys.self, forKey: .picture)
            .decode(String.self, forKey: .thumbnail)
    }
}
