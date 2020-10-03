//
//  TableViewLiaison+Registration.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 8/30/18.
//

import Foundation

extension TableViewLiaison {
    
    func register(section: TableViewSection) {
        
        section.option.header?.register(with: self)
        section.option.footer?.register(with: self)
        
        section.rows.forEach {
            $0.register(with: self)
        }
    }
    
    func register(sections: [TableViewSection]) {
        sections.forEach(register(section:))
    }
    
    func register(row: AnyTableViewRow) {
        row.register(with: self)
    }
    
    func register(rows: [AnyTableViewRow]) {
        rows.forEach(register(row:))
    }
    
    public func register<T: UITableViewCell>(_ type: T.Type, with identifier: String) {
        tableView?.register(T.self, forCellReuseIdentifier: identifier)
    }
    
    public func register<T: UITableViewHeaderFooterView>(_ type: T.Type, with identifier: String) {
        tableView?.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func registerCell(nib: UINib, with identifier: String) {
        tableView?.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerHeaderFooterView(nib: UINib, with identifier: String) {
        tableView?.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func dequeue<T: UITableViewCell>(_ type: T.Type, with identifier: String) -> T {
        
        guard let tableView = tableView else {
            fatalError("TableViewLiaison must be liased with UITableView before dequeuing cell of type \(T.self)")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Failed to dequeue cell of type \(T.self).")
        }
        
        return cell
    }
    
    public func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type, with identifier: String) -> T {
        
        guard let tableView = tableView else {
            fatalError("TableViewLiaison must be liased with UITableView before dequeuing view of type \(T.self)")
        }
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Failed to dequeue view of type \(T.self).")
        }
        
        return view
    }
}
