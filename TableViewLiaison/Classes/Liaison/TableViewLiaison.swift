//
//  TableViewLiaison.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public final class TableViewLiaison: NSObject {
    
    public internal(set) weak var tableView: UITableView? {
        didSet { registerSections() }
    }
    
    public internal(set) var sections = [TableViewSection]()
    
    public weak var paginationDelegate: TableViewLiaisonPaginationDelegate?
    
    let paginationSectionID = UUID().uuidString
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
    
    public var visibleCells: [UITableViewCell] {
        return tableView?.visibleCells ?? []
    }
    
    public var indexPathsForVisibleRows: [IndexPath] {
         return tableView?.indexPathsForVisibleRows ?? []
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
        self.paginationSection = TableViewSection(id: paginationSectionID, rows: [paginationRow])
        
        super.init()
    }
    
    public func liaise(tableView: UITableView) {
        self.tableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }
    
    public func detach() {
        tableView?.delegate = nil
        tableView?.dataSource = nil
        tableView?.prefetchDataSource = nil
        
        tableView = nil
    }
    
    public func reloadData() {
        tableView?.reloadData()
    }
    
    public func reloadVisibleRows() {
        reloadRows(at: indexPathsForVisibleRows)
    }
    
    public func scroll(to indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition = .none, animated: Bool = true) {
        guard row(for: indexPath) != nil else { return }
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    public func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition = .none, animated: Bool = true) {
        tableView?.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
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
    
    public func cell(at indexPath: IndexPath) -> UITableViewCell? {
        return tableView?.cellForRow(at: indexPath)
    }
    
    public func headerView(for section: Int) -> UITableViewHeaderFooterView? {
        return tableView?.headerView(forSection: section)
    }
    
    public func footerView(for section: Int) -> UITableViewHeaderFooterView? {
        return tableView?.footerView(forSection: section)
    }
    
    public func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return tableView?.indexPath(for: cell)
    }
    
    public func indexPathForRow(at point: CGPoint) -> IndexPath? {
        return tableView?.indexPathForRow(at: point)
    }
    
    public func sectionIndexes(for id: String) -> [Int] {
        return sections.enumerated()
            .filter { $0.1.id == id }
            .map { $0.0 }
    }
    
    public func rowIndexPathes<T>(where predicate: (T) -> Bool) -> [IndexPath] {
        return sections
            .enumerated()
            .reduce([]) { (result, tuple) -> [IndexPath] in
                let (index, section) = tuple
                return result + section.rowIndexPaths(for: index, where: predicate)
        }
    }
    
    public func rect(for section: Int) -> CGRect {
        return tableView?.rect(forSection: section) ?? .zero
    }
    
    public func rectForHeader(in section: Int) -> CGRect {
        return tableView?.rectForHeader(inSection: section) ?? .zero
    }
    
    public func rectForFooter(in section: Int) -> CGRect {
        return tableView?.rectForFooter(inSection: section) ?? .zero
    }
    
    public func rectForRow(at indexPath: IndexPath) -> CGRect {
        return tableView?.rectForRow(at: indexPath) ?? .zero
    }
    
    public func row<Cell: UITableViewCell, Data>(for indexPath: IndexPath) -> TableViewRow<Cell, Data>? {
        return row(for: indexPath) as? TableViewRow<Cell, Data>
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
    
    @discardableResult
    func perform(_ command: TableViewRowCommand, at indexPath: IndexPath) -> IndexPath? {
        
        guard let cell = cell(at: indexPath) else { return nil }
        
        row(for: indexPath)?.perform(command,
                                     liaison: self,
                                     cell: cell,
                                     indexPath: indexPath)
        
        return indexPath
    }
    
    private func registerSections() {
        register(section: paginationSection)
        register(sections: sections)
    }
}
