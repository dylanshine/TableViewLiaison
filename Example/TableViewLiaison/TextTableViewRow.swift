//
//  PostTextTableViewRow.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import TableViewLiaison

final class TextTableViewRow: TableViewRow<TextTableViewCell, String> {
    
    init(text: String) {
        super.init(text,
                   registrationType: .defaultNibType)
    }
    
}
