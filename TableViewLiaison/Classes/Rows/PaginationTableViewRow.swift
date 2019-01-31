//
//  PaginationTableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/30/18.
//

import UIKit

public final class PaginationTableViewRow: TableViewRow<PaginationTableViewCell, Void> {
    
    public init() {
        super.init(())
        
        set(command: .configuration) { cell, _, _ in
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
        }
        
        set(command: .willDisplay) { cell, _, _ in
            cell.spinner.startAnimating()
        }
    }
}
