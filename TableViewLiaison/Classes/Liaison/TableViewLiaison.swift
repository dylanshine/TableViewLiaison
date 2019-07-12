//
//  TableViewLiaison.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public final class TableViewLiaison: NSObject {
    
    weak var tableView: UITableView? {
        didSet { registerSections() }
    }
    
    public internal(set) var sections = [TableViewSection]()
    
    public weak var paginationDelegate: TableViewLiaisonPaginationDelegate?
    
    let paginationSection: TableViewSection
    
    var waitingForPaginatedResults = false
    
    public var isEditing: Bool {
        get { return tableView?.isEditing ?? false }
        set { tableView?.isEditing = newValue }
    }
    
    public var allowsSelection: Bool {
        get { return tableView?.allowsSelection ?? false }
        set { tableView?.allowsSelection = newValue }
    }
    
    public var allowsSelectionDuringEditing: Bool {
        get { return tableView?.allowsSelectionDuringEditing ?? false }
        set { tableView?.allowsSelectionDuringEditing = newValue }
    }
    
    public var allowsMultipleSelection: Bool {
        get { return tableView?.allowsMultipleSelection ?? false }
        set { tableView?.allowsMultipleSelection = newValue }
    }
    
    public var allowsMultipleSelectionDuringEditing: Bool {
        get { return tableView?.allowsMultipleSelectionDuringEditing ?? false }
        set { tableView?.allowsMultipleSelectionDuringEditing = newValue }
    }
    
    public var indexPathForSelectedRow: IndexPath? {
        return tableView?.indexPathForSelectedRow
    }
    
    public var indexPathsForSelectedRows: [IndexPath] {
        return tableView?.indexPathsForSelectedRows ?? []
    }
    
    public init(sections: [TableViewSection] = [],
                paginationRow: AnyTableViewRow = paginationRow) {
        self.sections = sections
        self.paginationSection = TableViewSection(rows: [paginationRow])
        
        super.init()
    }
    
    public func liaise(tableView: UITableView) {
        self.tableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
    }
    
    public func detach() {
        tableView?.delegate = nil
        tableView?.dataSource = nil
        
        if #available(iOS 10.0, *) {
            tableView?.prefetchDataSource = nil
        }
        
        tableView = nil
    }
    
    public func reloadData() {
        tableView?.reloadData()
    }
    
    public func reloadVisibleRows() {
        guard let indexPaths = tableView?.indexPathsForVisibleRows else { return }
        reloadRows(at: indexPaths)
    }
    
    public func scroll(to indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition = .none, animated: Bool = true) {
        guard row(for: indexPath) != nil else { return }
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }

    public func toggleIsEditing() {        
        tableView?.isEditing.toggle()
    }
    
    public func lastIndexPath(in section: Int) -> IndexPath? {
        guard let row = sections.element(at: section)?.rows.count else { return nil }
        guard row > 1 else { return IndexPath(row: 0, section: section) }
        return IndexPath(row: row - 1, section: section)
    }
    
    public func selectRow(at indexPath: IndexPath,
                          animated: Bool = true,
                          scrollPosition: UITableView.ScrollPosition = .none) {
        tableView?.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
    public func deselectRow(at indexPath: IndexPath, animated: Bool = true) {
        tableView?.deselectRow(at: indexPath, animated: animated)
    }
    
    func sectionIndexes(for identifier: String) -> Set<Int> {
        return Set(sections.enumerated()
            .filter { $0.1.identifier == identifier }
            .map { $0.0 })
    }
    
    func rowIndexPaths(for identifier: String) -> Set<IndexPath> {
        return Set(sections
            .enumerated()
            .reduce([]) { (result, tuple) -> [IndexPath] in
                let (index, section) = tuple
                return result + section.rowIndexPaths(for: identifier, section: index)
        })
    }
    
    func rowIndexPaths(for identifier: String, in sectionIdentfier: String) -> Set<IndexPath> {
        let sectionIndexes = self.sectionIndexes(for: sectionIdentfier)
        
        return Set(sectionIndexes.reduce([]) { (result, index) -> [IndexPath] in
            return result + sections[index].rowIndexPaths(for: identifier, section: index)
        })
    }
    
    func row(for indexPath: IndexPath) -> AnyTableViewRow? {
        guard let section = sections.element(at: indexPath.section) else { return nil }
        
        return section.rows.element(at: indexPath.row)
    }
    
    func canMove(to indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.movable ?? false
    }
    
    func performTableViewUpdates(animated: Bool, _ closure: () -> Void) {
        if animated {
            tableView?.beginUpdates()
            closure()
            tableView?.endUpdates()
        } else {
            reloadData()
        }
    }
    
    private func registerSections() {
        register(section: paginationSection)
        register(sections: sections)
    }
}
