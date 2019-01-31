//
//  TableViewLiaison+Registration.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 8/30/18.
//

import Foundation

extension TableViewLiaison {
    
    func register(section: TableViewSection) {
        guard let tableView = tableView else { return }
        
        section.componentDisplayOption.header?.register(with: tableView)
        section.componentDisplayOption.footer?.register(with: tableView)
        
        section.rows.forEach {
            $0.register(with: tableView)
        }
    }
    
    func register(sections: [TableViewSection]) {
        sections.forEach(register(section:))
    }
    
    func register(row: AnyTableViewRow) {
        guard let tableView = tableView else { return }
        row.register(with: tableView)
    }
    
    func register(rows: [AnyTableViewRow]) {
        rows.forEach(register(row:))
    }
}
