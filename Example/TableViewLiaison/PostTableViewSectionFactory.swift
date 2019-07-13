//
//  PostTableViewSectionFactory.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import TableViewLiaison

enum PostTableViewSectionFactory {
    
    static func section(for post: Post,
                        liaison: TableViewLiaison) -> TableViewSection {
        let rows: [AnyTableViewRow] = [
            TableViewContentFactory.imageRow(imageSize: post.imageSize),
            TableViewContentFactory.likesRow(numberOfLikes: post.numberOfLikes),
            TableViewContentFactory.captionRow(user: post.user.username, liaison: liaison),
            TableViewContentFactory.commentRow(commentCount: post.numberOfComments),
            TableViewContentFactory.timeRow(numberOfSeconds: post.timePosted)
        ]
        
        let header = TableViewContentFactory.postSectionHeaderComponent(user: post.user)
        
        return TableViewSection(id: post.id,
                                rows: rows,
                                componentDisplayOption: .header(component: header))
    }
    
}
