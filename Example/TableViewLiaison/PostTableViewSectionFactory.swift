//
//  PostTableViewSectionFactory.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import TableViewLiaison

enum PostTableViewSectionFactory {
    
    static func section(for post: Post) -> TableViewSection {
        let rows: [AnyTableViewRow] = [
            TableViewContentFactory.imageRow(id: post.id, imageSize: post.imageSize),
            TableViewRow(ActionButtonsTableViewCell.self, registrationType:.defaultNibType),
            TableViewContentFactory.likesRow(numberOfLikes: post.numberOfLikes),
            TableViewContentFactory.captionRow(id: post.id),
            TableViewContentFactory.commentRow(commentCount: post.numberOfComments),
            TableViewContentFactory.timeRow(numberOfSeconds: post.timePosted)
        ]
        
        let header = TableViewContentFactory.postSectionHeaderComponent(id: post.id)
        
        return TableViewSection(id: post.id,
                                rows: rows,
                                option: .header(component: header))
    }
    
}
