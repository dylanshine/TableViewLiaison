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
    
    static func imageRow(id: String, imageSize: CGSize) -> TableViewRow<ImageTableViewCell> {
        
        var row = TableViewRow<ImageTableViewCell>(registrationType: .defaultNibType)
        
        row.set(height: .height) {
            
            let ratio = imageSize.width / imageSize.height
            
            return UIScreen.main.bounds.width / ratio
        }
        
        func fetchImage(for indexPath: IndexPath, completion: ((UIImage?) -> Void)? = nil) {
            
            let width = Int(imageSize.width * 2.0)
            let height = Int(imageSize.height * 2.0)
            
            NetworkManager.fetchRandomPostImage(id: id,
                                                width: width,
                                                height: height) { image in
                completion?(image)
            }
        }
        
        row.set(prefetchCommand: .prefetch) { indexPath in
            fetchImage(for: indexPath)
        }
        
        row.set(command: .configuration) { (liaison: TableViewLiaison, cell: ImageTableViewCell, indexPath: IndexPath) in
            fetchImage(for: indexPath) { [weak cell] image in
                cell?.contentImage = image
            }
        }
        
        return row
    }
    
    private static func textTableViewRow() -> TableViewRow<TextTableViewCell> {
        return TableViewRow<TextTableViewCell>(registrationType: .defaultNibType)
    }
    
    static func likesRow(numberOfLikes: UInt) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()
        
        row.set(command: .configuration) { _, cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.contentTextLabel.text = "\(numberOfLikes) likes"
            cell.contentTextLabel.textColor = .white
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func captionRow(id: String, user: String) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()

        row.set(prefetchCommand: .prefetch) { indexPath in
            NetworkManager.fetchRandomFact(id: id)
        }
        
        func configureContentText(fact: String,
                                  for cell: TextTableViewCell) {
            
            cell.contentTextLabel.numberOfLines = 0
            
            let mediumAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: UIColor.white
            ]
            
            let regularAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.white
            ]
            
            let attributedString = NSMutableAttributedString(string: user, attributes: mediumAttributes)
            
            attributedString.append(NSMutableAttributedString(string: " \(fact)", attributes: regularAttributes))
            cell.contentTextLabel.attributedText = attributedString
        }
        
        row.set(command: .configuration) { liaison, cell, indexPath in
            
            if let fact = NetworkManager.factCache[id] {
                configureContentText(fact: fact, for: cell)
                return
            }
            
            NetworkManager.fetchRandomFact(id: id) { [weak liaison, weak cell] fact in
                guard let fact = fact,
                    let liaison = liaison,
                    let cell = cell else { return }
                
                configureContentText(fact: fact, for: cell)
                
                DispatchQueue.main.async {
                    liaison.reloadRow(at: indexPath)
                }
                
            }
        }
        
        return row
    }
    
    static func commentRow(commentCount: UInt) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()
        
        row.set(command: .configuration) { _, cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13)
            cell.contentTextLabel.text = "View all \(commentCount) comments"
            cell.contentTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func timeRow(numberOfSeconds: TimeInterval) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()

        row.set(command: .configuration) { _, cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 10)
            cell.contentTextLabel.text = numberOfSeconds.timeText
            cell.contentTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func postSectionHeaderComponent(post: Post) -> TableViewSectionComponent<PostTableViewSectionHeaderView> {
        
        var header = TableViewSectionComponent<PostTableViewSectionHeaderView>(registrationType: .defaultNibType)
        
        header.set(height: .height, 70)
        
        header.set(command: .configuration) { liaison, view, _ in
            
            view.imageView.image = post.user.avatar
            view.titleLabel.text = post.user.username

            view.swapAction = { [weak liaison] in
                guard let sectionIndex = liaison?.sectionIndexes(for: post.id).first else { return }
                liaison?.swapSection(at: sectionIndex, with: sectionIndex + 1)
            }
            
            view.hideAction = { [weak liaison] in
                NetworkManager.flushCache(for: post.id)
                liaison?.deleteSections(with: post.id, animation: .fade)
            }
        
        }
        
        return header
    }
    
}
