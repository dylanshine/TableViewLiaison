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
    
    static func imageRow(imageSize: CGSize) -> TableViewRow<ImageTableViewCell> {
        
        var row = TableViewRow<ImageTableViewCell>(registrationType: .defaultNibType)
        
        row.set(height: .height) {
            
            let ratio = imageSize.width / imageSize.height
            
            return UIScreen.main.bounds.width / ratio
        }
        
        func fetchImage(for indexPath: IndexPath, completion: ((UIImage?) -> Void)? = nil) {
            if let image = NetworkManager.imageCache[indexPath] {
                completion?(image)
                return
            }
            
            let width = Int(imageSize.width)
            let height = Int(imageSize.height)
            
            NetworkManager.fetchRandomPostImage(width: width, height: height) { image in
                NetworkManager.imageCache[indexPath] = image
                completion?(image)
            }
        }
        
        row.set(prefetchCommand: .prefetch) { indexPath in
            fetchImage(for: indexPath)
        }
        
        row.set(command: .configuration) { (cell: ImageTableViewCell, indexPath: IndexPath) in
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
        
        row.set(command: .configuration) { cell, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.contentTextLabel.text = "\(numberOfLikes) likes"
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func captionRow(user: String, liaison: TableViewLiaison) -> TableViewRow<TextTableViewCell> {
        
        var row = textTableViewRow()
        
        let fetchFact: ((IndexPath, ((String?) -> Void)?) -> ()) = { [weak liaison] indexPath, completion in
            
            if let fact = NetworkManager.factCache[indexPath] {
                completion?(fact)
                return
            }
            
            NetworkManager.fetchRandomFact { fact in
                NetworkManager.factCache[indexPath] = fact
                completion?(fact)
                
                DispatchQueue.main.async {
                    liaison?.reloadRow(at: indexPath)
                }
            }
        }
    
        
        row.set(prefetchCommand: .prefetch) { indexPath in
            fetchFact(indexPath, nil)
        }
        
        row.set(command: .configuration) { cell, indexPath in
            
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
            
            let completion: (String?) -> Void = { [weak cell] fact in
                guard let fact = fact else { return }
                
                attributedString.append(NSMutableAttributedString(string: " \(fact)", attributes: regularAttributes))
                
                cell?.contentTextLabel.attributedText = attributedString
                
            }
            
            fetchFact(indexPath, completion)
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
