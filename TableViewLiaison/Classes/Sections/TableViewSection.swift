//
//  TableViewSection.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 8/28/18.
//

import UIKit

public struct TableViewSection {
    
    public internal(set) var rows: [AnyTableViewRow]
    
    public let id: String?
    public let option: TableViewSectionComponentDisplayOption
    
    public init(id: String? = nil,
                rows: [AnyTableViewRow] = [],
                option: TableViewSectionComponentDisplayOption = .none) {
        self.rows = rows
        self.id = id
        self.option = option
    }
    
    func perform(_ command: TableViewSectionComponentCommand,
                 componentView: TableViewSectionComponentViewType,
                 liaison: TableViewLiaison,
                 view: UIView,
                 section: Int) {
        
        switch componentView {
        case .header:
            option.header?.perform(command, liaison: liaison, view: view, section: section)
        case .footer:
            option.footer?.perform(command, liaison: liaison, view: view, section: section)
        }
    }
    
    func view(componentView: TableViewSectionComponentViewType, for liaison: TableViewLiaison, in section: Int) -> UIView? {
        switch componentView {
        case .header:
            return option.header?.view(for: liaison, in: section)
        case .footer:
            return option.footer?.view(for: liaison, in: section)
        }
    }
    
    func calculate(height: TableViewHeightType, for componentView: TableViewSectionComponentViewType) -> CGFloat {
        
        switch (option, componentView) {
        case (.both(let header, _), .header):
            return calculate(height, for: header)
        case (.both(_, let footer), .footer):
            return calculate(height, for: footer)
        case (.header(let header), .header):
            return calculate(height, for: header)
        case (.footer(let footer), .footer):
            return calculate(height, for: footer)
        default:
            if #available(iOS 11.0, *) {
                return .leastNormalMagnitude
            } else {
                return 0
            }
        }
    }
    
    private func calculate(_ height: TableViewHeightType, for sectionComponent: AnyTableViewSectionComponent) -> CGFloat {
        switch height {
        case .height:
            return sectionComponent.height
        case .estimatedHeight:
            return sectionComponent.estimatedHeight
        }
    }
    
    // MARK: - Helpers
    func rowIndexPaths(for section: Int) -> [IndexPath] {
        return rows.enumerated().map { item, _ -> IndexPath in
            return IndexPath(item: item, section: section)
        }
    }
    
    func rowIndexPaths<T>(for section: Int, where predicate: (T) -> Bool) -> [IndexPath] {
        return rows.enumerated()
            .filter { index, row in
                guard let state = row.data as? T else { return false }
                return predicate(state)
            }
            .map { item, _ -> IndexPath in
                return IndexPath(item: item, section: section)
        }
    }

    
    // MARK: - Helpers
    mutating func append(row: AnyTableViewRow) {
        rows.append(row)
    }
    
    mutating func append(rows: [AnyTableViewRow]) {
        self.rows.append(contentsOf: rows)
    }
    
    @discardableResult
    mutating func deleteRow(at indexPath: IndexPath) -> AnyTableViewRow? {
        guard rows.indices.contains(indexPath.item) else { return nil }
        return rows.remove(at: indexPath.item)
    }
    
    mutating func insert(row: AnyTableViewRow, at indexPath: IndexPath) {
        guard rows.count >= indexPath.item else { return }
        rows.insert(row, at: indexPath.item)
    }
    
    mutating func swapRows(at source: IndexPath, to destination: IndexPath) {
        guard rows.indices.contains(source.item) && rows.indices.contains(destination.item) else { return }
        rows.swapAt(source.item, destination.item)
    }
    
    mutating func removeAllRows() {
        rows.removeAll()
    }
}
