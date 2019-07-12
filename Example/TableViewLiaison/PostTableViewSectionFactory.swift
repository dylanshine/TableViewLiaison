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
    
    static func section(for post: Post, tableView: UITableView) -> TableViewSection {
        let rows: [AnyTableViewRow] = [
            TableViewContentFactory.imageRow(image: post.content, tableView: tableView),
            TableViewContentFactory.actionButtonRow(),
            TableViewContentFactory.likesRow(numberOfLikes: post.numberOfLikes),
            TableViewContentFactory.captionRow(user: post.user.username, caption: post.caption),
            TableViewContentFactory.commentRow(commentCount: post.numberOfComments),
            TableViewContentFactory.timeRow(numberOfSeconds: post.timePosted)
        ]
        
        let header = TableViewContentFactory.postSectionHeaderComponent(user: post.user)
        
        return TableViewSection(rows: rows, componentDisplayOption: .header(component: header))
    }
    
}
