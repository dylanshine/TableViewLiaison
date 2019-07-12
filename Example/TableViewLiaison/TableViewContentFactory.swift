//
//  TableViewContentFactory.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import TableViewLiaison
import UIKit

enum TableViewContentFactory {
    
    static func imageRow(image: UIImage, tableView: UITableView) -> TableViewRow<ImageTableViewCell> {
        
        var row = TableViewRow<ImageTableViewCell>(registrationType: .defaultNibType)
        
        row.set(height: .height) { [weak tableView] in
            
            guard let tableView = tableView else {
                return 0
            }
            
            let ratio = image.size.width / image.size.height
            
            return tableView.frame.width / ratio
        }
        
        row.set(command: .configuration) { cell, _ in
            cell.contentImageView.image = image
            cell.contentImageView.contentMode = .scaleAspectFill
        }
        
        return row
    }
    
    static func actionButtonRow() -> TableViewRow<ActionButtonsTableViewCell> {
        
        var row = TableViewRow<ActionButtonsTableViewCell>(registrationType: .defaultNibType)
        
        row.set(height: .height, 30)
        
        row.set(command: .configuration) { cell, _ in
            cell.likeButton.setTitle("❤️", for: .normal)
            cell.commentButton.setTitle("💬", for: .normal)
            cell.messageButton.setTitle("📮", for: .normal)
            cell.bookmarkButton.setTitle("📚", for: .normal)
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    private static func textTableViewRow() -> TableViewRow<TextTableViewCell> {
        return TableViewRow<TextTableViewCell>(registrationType: .defaultNibType)
    }
    
    static func likesRow(numberOfLikes: UInt) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()
        
        row.set(command: .configuration) { cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.contentTextLabel.text = "\(numberOfLikes) likes"
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func captionRow(user: String, caption: String) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()
        
        row.set(command: .configuration) { cell, _ in
            
            cell.contentTextLabel.numberOfLines = 0
            cell.selectionStyle = .none
            
            let mediumAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: UIColor.black
            ]
            
            let regularAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black
            ]
            
            let attributedString = NSMutableAttributedString(string: user, attributes: mediumAttributes)
            
            attributedString.append(NSMutableAttributedString(string: " \(caption)", attributes: regularAttributes))
            
            cell.contentTextLabel.attributedText = attributedString
        }
        
        return row
    }
    
    static func commentRow(commentCount: UInt) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()
        
        row.set(command: .configuration) { cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13)
            cell.contentTextLabel.text = "View all \(commentCount) comments"
            cell.contentTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func timeRow(numberOfSeconds: TimeInterval) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()

        row.set(command: .configuration) { cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 10)
            cell.contentTextLabel.text = numberOfSeconds.timeText
            cell.contentTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func postSectionHeaderComponent(user: User) -> TableViewSectionComponent<PostTableViewSectionHeaderView> {
        
        var header = TableViewSectionComponent<PostTableViewSectionHeaderView>(registrationType: .defaultNibType)
        
        header.set(height: .height, 70)
        
        header.set(command: .configuration) { view, section in
            view.backgroundView = UIView(frame: view.bounds)
            view.backgroundView?.backgroundColor = .white
            
            view.imageView.image = user.avatar
            view.imageView.layer.borderColor = UIColor.gray.cgColor
            view.imageView.layer.borderWidth = 1
            
            view.titleLabel.text = user.username
            view.titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
            view.titleLabel.textColor = .black
        }
        
        return header
    }
    
}
