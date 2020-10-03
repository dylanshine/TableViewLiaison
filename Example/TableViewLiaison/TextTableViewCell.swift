//
//  TextTableViewCell.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 Shine Labs. All rights reserved.
//

import UIKit

final class TextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentTextLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentTextLabel.text = nil
        contentTextLabel.attributedText = nil
    }
    
}
