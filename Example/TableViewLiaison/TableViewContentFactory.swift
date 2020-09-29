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
    
    static func imageRow(id: String, imageSize: CGSize) -> AnyTableViewRow {
        
        var row = TableViewRow(ImageTableViewCell.self, data: id, registrationType: .defaultNibType)
        
        row.set(.height) {
            
            let ratio = imageSize.width / imageSize.height
            
            return UIScreen.main.bounds.width / ratio
        }
        
        row.set(.prefetch) { id, _ in
            fetchImage(id: id, imageSize: imageSize)
        }
        
        row.set(.configuration) { (_, cell: ImageTableViewCell, _, _) in
            fetchImage(id: id, imageSize: imageSize) { [weak cell] image in
                cell?.contentImage = image
            }
        }
        
        return row
    }
    
    private static func fetchImage(id: String,
                                   imageSize: CGSize,
                                   completion: ((UIImage?) -> Void)? = nil) {
        
        let width = Int(imageSize.width * 2.0)
        let height = Int(imageSize.height * 2.0)
        
        NetworkManager.fetchRandomPostImage(id: id,
                                            width: width,
                                            height: height,
                                            completion: completion)
    }
    
    private static func textTableViewRow() -> TableViewRow<TextTableViewCell, Void> {
        return TableViewRow(TextTableViewCell.self, registrationType: .defaultNibType)
    }
    
    static func likesRow(numberOfLikes: UInt) -> AnyTableViewRow {
        
        var row = textTableViewRow()
        
        row.set(.configuration) { _, cell, _, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.contentTextLabel.text = "\(numberOfLikes) likes"
            cell.contentTextLabel.textColor = .white
        }
        
        return row
    }
    
    static func captionRow(id: String) -> AnyTableViewRow {
        
        var row = textTableViewRow()

        row.set(.estimatedHeight, 50)
        
        row.set(.prefetch) { indexPath in
            NetworkManager.fetchRandomFact(id: id)
        }
        
        row.set(.configuration) { liaison, cell, _,  indexPath in
            
            cell.contentTextLabel.numberOfLines = 0
            cell.contentTextLabel.textColor = .white
            cell.contentTextLabel.font = .systemFont(ofSize: 13)
            
            NetworkManager.fetchRandomFact(id: id) { [weak cell] fact in
                guard let fact = fact,
                    let cell = cell else { return }
                
                cell.contentTextLabel.text = fact
            }
        }
        
        return row
    }
    
    static func commentRow(commentCount: UInt) -> AnyTableViewRow {
        
        var row = textTableViewRow()
        
        row.set(.configuration) { _, cell, _, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13)
            cell.contentTextLabel.text = "View all \(commentCount) comments"
            cell.contentTextLabel.textColor = .gray
        }
        
        return row
    }
    
    static func timeRow(numberOfSeconds: TimeInterval) -> AnyTableViewRow {
        
        var row = textTableViewRow()

        row.set(.configuration) { _, cell, _, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 10)
            cell.contentTextLabel.text = numberOfSeconds.timeText
            cell.contentTextLabel.textColor = .gray
        }
        
        return row
    }
    
    static func postSectionHeaderComponent(id: String) -> TableViewSectionComponent<PostTableViewSectionHeaderView> {
        
        var header = TableViewSectionComponent<PostTableViewSectionHeaderView>(registrationType: .defaultNibType)
        
        header.set(.height, 70)
        
        header.set(.configuration) { liaison, view, _ in
            
            NetworkManager.fetchRandomUser(id: id) { [weak view] user in
                guard let user = user else { return }
                view?.titleLabel.text = user.username
                
                NetworkManager.fetchImage(url: user.thumbnail) { [weak view] image in
                    view?.imageView.image = image
                }
            }
            
            view.swapAction = { [weak liaison] in
                guard let sectionIndex = liaison?.sectionIndexes(for: id).first else { return }
                liaison?.swapSection(at: sectionIndex, with: sectionIndex + 1)
            }
            
            view.hideAction = { [weak liaison] in
                NetworkManager.flushCache(for: id)
                liaison?.deleteSections(with: id, animation: .fade)
            }
        
        }
        
        return header
    }
    
}
