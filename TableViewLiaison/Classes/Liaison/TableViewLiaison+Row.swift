//
//  TableViewLiaison+Row.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

public extension TableViewLiaison {
    
    func append(rows: [AnyTableViewRow], to section: Int = 0, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        if waitingForPaginatedResults {
            endPagination(rows: rows, to: section, animation: animation, animated: animated)
            return
        }
        
        guard sections.indices.contains(section),
            !rows.isEmpty else { return }
        
        var lastRowIndex = sections[section].rows.count - 1
                
        sections[section].append(rows: rows)
        register(rows: rows)
        
        let indexPaths = rows.map { row -> IndexPath in
            lastRowIndex += 1
            return IndexPath(row: lastRowIndex, section: section)
        }
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertRows(at: indexPaths, with: animation)
        }
        
        zip(rows, indexPaths).forEach { row, indexPath in
            if let cell = cell(at: indexPath) {
                row.perform(.insert, liaison: self, cell: cell, indexPath: indexPath)
            }
        }
        
    }
    
    func append(rows: [AnyTableViewRow], to sectionId: String, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard !rows.isEmpty else { return }
        
        let sectionIndexes = self.sectionIndexes(for: sectionId)
        
        var rowIndexPathZip = [(AnyTableViewRow, IndexPath)]()
        
        for section in sectionIndexes {
            var lastRowIndex = sections[section].rows.count - 1
            sections[section].append(rows: rows)
            register(rows: rows)
            
            let zip = rows.map { row -> (AnyTableViewRow, IndexPath) in
                lastRowIndex += 1
                let indexPath = IndexPath(row: lastRowIndex, section: section)
                return (row, indexPath)
            }
            
            rowIndexPathZip.append(contentsOf: zip)
        }
        
        let indexPaths = rowIndexPathZip.map { $0.1 }
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertRows(at: indexPaths, with: animation)
        }
        
        rowIndexPathZip.forEach { row, indexPath in
            if let cell = cell(at: indexPath) {
                row.perform(.insert, liaison: self, cell: cell, indexPath: indexPath)
            }
        }
    }
    
    func append(row: AnyTableViewRow, to section: Int = 0, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        append(rows: [row], to: section, animation: animation, animated: animated)
    }
    
    func append(row: AnyTableViewRow, to sectionId: String, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        append(rows: [row], to: sectionId, animation: animation, animated: animated)
    }
    
    func insert(row: AnyTableViewRow, at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(indexPath.section),
            sections[indexPath.section].rows.indices.contains(indexPath.row) else { return }
        
        sections[indexPath.section].insert(row: row, at: indexPath.item)
        register(row: row)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertRows(at: [indexPath], with: animation)
        }
        
        perform(.insert, at: indexPath)

    }
    
    @discardableResult
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic, animated: Bool = true) -> [AnyTableViewRow] {
        
        guard !indexPaths.isEmpty else { return [] }
        
        let indexPaths = Array(Set(indexPaths))
        let sortedIndexPaths = indexPaths.sortBySection()
        var deletedRows = [AnyTableViewRow]()
        
        sortedIndexPaths.forEach { section, indexPaths in
            if sections.indices.contains(section) {
                
                indexPaths.forEach {
                    
                    if let row = sections[section].deleteRow(at: $0.item) {
                        deletedRows.append(row)
                        
                        if let cell = cell(at: $0) {
                            row.perform(.delete, liaison: self, cell: cell, indexPath: $0)
                        }
                    }
                }
                
                performTableViewUpdates(animated: animated) {
                    tableView?.deleteRows(at: indexPaths, with: animation)
                }
            }
        }
        
        return deletedRows
        
    }
    
    @discardableResult
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic, animated: Bool = true) -> AnyTableViewRow? {
        
        guard sections.indices.contains(indexPath.section),
            sections[indexPath.section].rows.indices.contains(indexPath.row)else { return nil }
        
        let row = sections[indexPath.section].deleteRow(at: indexPath.item)
        
        if let cell = cell(at: indexPath) {
            row?.perform(.delete, liaison: self, cell: cell, indexPath: indexPath)
        }
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
        }
        
        return row
    }
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic) {
        tableView?.reloadRows(at: indexPaths, with: animation)
        
        indexPaths.forEach {
            perform(.reload, at: $0)
        }
    }
    
    func reloadRow(at indexPath: IndexPath, animation: UITableView.RowAnimation = .automatic) {
        reloadRows(at: [indexPath], with: animation)
    }
    
    func replaceRow(at indexPath: IndexPath, with row: AnyTableViewRow, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(indexPath.section),
            sections[indexPath.section].rows.indices.contains(indexPath.row) else { return }
        
        let deletedRow = sections[indexPath.section].deleteRow(at: indexPath.item)
        if let cell = cell(at: indexPath) {
            deletedRow?.perform(.delete, liaison: self, cell: cell, indexPath: indexPath)
        }
        
        sections[indexPath.section].insert(row: row, at: indexPath.item)
        register(row: row)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
            tableView?.insertRows(at: [indexPath], with: animation)
        }
        
        if let cell = cell(at: indexPath) {
            row.perform(.insert, liaison: self, cell: cell, indexPath: indexPath)
        }
    }
    
    func moveRow(from source: IndexPath, to destination: IndexPath, animated: Bool = true) {
        let indices = sections.indices
        guard indices.contains(source.section) && indices.contains(destination.section) else { return }
        
        guard let row = sections[source.section].deleteRow(at: source.item) else {
            return
        }
        
        sections[destination.section].insert(row: row, at: destination.item)
        
        perform(.move, at: destination)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveRow(at: source, to: destination)
        }
    }
    
    func swapRow(at source: IndexPath, with destination: IndexPath, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        let indices = sections.indices
        guard indices.contains(source.section) && indices.contains(destination.section) else { return }
        
        if source.section == destination.section {
            sections[source.section].swapRows(at: source.item, to: destination.item)
        } else {

            guard let sourceRow = sections[source.section].deleteRow(at: source.item),
                  let destinationRow = sections[destination.section].deleteRow(at: destination.item) else { return }
            
            sections[source.section].insert(row: destinationRow, at: source.item)
            sections[destination.section].insert(row: sourceRow, at: destination.item)
        }
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveRow(at: source, to: destination)
            tableView?.moveRow(at: destination, to: source)
        }
        
        perform(.move, at: source)
        perform(.move, at: destination)
    }
}
