//
//  ImageTableViewCell.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 Shine Labs. All rights reserved.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {

    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var contentImageView: UIImageView!
    
    var contentImage: UIImage? {
        get { return contentImageView.image }
        set {
            if let image = newValue{
                contentImageView.image = image
                spinner.stopAnimating()
            } else {
                contentImageView.image = nil
                spinner.isHidden = false
                spinner.startAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage = nil
    }
    
}
