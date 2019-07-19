//
//  PostTableViewSectionHeaderView.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 1/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

final class PostTableViewSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var hideButton: UIButton!
    var hideButtonAction = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        hideButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // There is a UIKit bug where outlets for the view will be nil on first layout pass.
        guard imageView != nil else { return }
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        hideButtonAction = {}
    }
    
    @IBAction private func hideButtonPressed(_ sender: Any) {
        hideButtonAction()
    }
}
