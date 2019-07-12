//
//  TableViewLiaison+Section.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

public extension TableViewLiaison {
    
    func append(sections: [TableViewSection], animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        if waitingForPaginatedResults {
            endPagination(sections: sections, animation: animation, animated: animated)
            return
        }
        
        guard !sections.isEmpty else { return }
        
        let lowerBound = self.sections.count
        let upperBound = lowerBound + sections.lastIndex
        let indexSet = IndexSet(integersIn: lowerBound...upperBound)
        
        self.sections.append(contentsOf: sections)
        register(sections: sections)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(indexSet, with: animation)
        }
        
    }
    
    func append(section: TableViewSection, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        append(sections: [section], animation: animation, animated: animated)
    }
    
    func insert(sections: [TableViewSection], startingAt index: Int, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        guard !sections.isEmpty else { return }

        let indexRange = (index...(index + sections.count))
        
        zip(sections, indexRange)
            .forEach { section, index in
                self.sections.insert(section, at: index)
        }

        register(sections: sections)
        let indexSet = IndexSet(integersIn: indexRange)
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(indexSet, with: animation)
        }
    }
    
    func insert(section: TableViewSection, at index: Int, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        sections.insert(section, at: index)
        register(section: section)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(IndexSet(integer: index), with: animation)
        }
    }
    
    func emptySection(at index: Int, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(index) else { return }
        
        let indexPaths = sections[index].rowIndexPaths(for: index)
        sections[index].removeAllRows()
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: indexPaths, with: animation)
        }
        
    }
    
    func deleteSection(at index: Int, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(index) else { return }
        
        sections.remove(at: index)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(IndexSet(integer: index), with: animation)
        }
    }
    
    func deleteSections(at indexes: Set<Int>, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        let indexes = indexes
            .filter { sections.indices.contains($0) }
            .sorted(by: >)
        
        indexes.forEach { sections.remove(at: $0) }
        
        let indexSet = IndexSet(indexes)
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(indexSet, with: animation)
        }
    }
    
    func replaceSection(at index: Int, with section: TableViewSection, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {

        guard sections.indices.contains(index) else { return }
        
        sections.remove(at: index)
        sections.insert(section, at: index)
        register(section: section)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(IndexSet(integer: index), with: animation)
            tableView?.insertSections(IndexSet(integer: index), with: animation)
        }
    }
    
    func reloadSection(at index: Int, with animation: UITableView.RowAnimation = .automatic) {
        tableView?.beginUpdates()
        tableView?.reloadSections(IndexSet(integer: index), with: animation)
        tableView?.endUpdates()
    }
    
    func moveSection(at: Int, to: Int, with animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(at) else { return }
    
        let section = sections.remove(at: at)
        sections.insert(section, at: to)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveSection(at, toSection: to)
        }
    }
    
    func clearSections(replacedBy sections: [TableViewSection] = [],
                       animation: UITableView.RowAnimation = .automatic,
                       animated: Bool = true) {
        
        if !self.sections.isEmpty {
            let sectionsRange = 0...self.sections.lastIndex
            let indexSet = IndexSet(integersIn: sectionsRange)
            
            self.sections.removeAll()
            
            performTableViewUpdates(animated: animated) {
                tableView?.deleteSections(indexSet, with: animation)
            }
        }
        
        append(sections: sections, animation: animation, animated: animated)
    }
    
    func swapSection(at source: Int, with destination: Int, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(source) && sections.indices.contains(destination) else { return }
        sections.swapAt(source, destination)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveSection(source, toSection: destination)
            tableView?.moveSection(destination, toSection: source)
        }
    }
}
