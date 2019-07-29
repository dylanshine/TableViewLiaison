//
//  Post.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/30/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit

struct Post {
    
    let imageSize = CGSize(width: CGFloat.random(in: 200...300),
                           height: CGFloat.random(in: 200...300))
    let numberOfLikes = UInt.random(in: 1...5000)
    let numberOfComments = UInt.random(in: 1...600)
    let timePosted = TimeInterval.random(in: 1...1000000)
    let id: String = UUID().uuidString
    
}
