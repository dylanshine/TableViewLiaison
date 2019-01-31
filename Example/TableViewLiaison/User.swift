//
//  User.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct User {
    
    let username: String
    let avatar: UIImage
    
    static var dylan: User {
        return User(username: "dylan", avatar: #imageLiteral(resourceName: "dylan"))
    }
    
}
