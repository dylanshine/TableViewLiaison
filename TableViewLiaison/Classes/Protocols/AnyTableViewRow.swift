//
//  AnyTableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/24/18.
//

import UIKit

public protocol AnyTableViewRow: TableViewContent {
    var data: Any? { get }
    var editable: Bool { get }
    var movable: Bool { get }
    var editActions: [UITableViewRowAction]? { get }
    var editingStyle: UITableViewCell.EditingStyle { get }
    var indentWhileEditing: Bool { get }
    var deleteConfirmationTitle: String? { get }
    var deleteRowAnimation: UITableView.RowAnimation { get }
    func cell(for liaison: TableViewLiaison, at indexPath: IndexPath) -> UITableViewCell
    func perform(command: TableViewRowCommand, liaison: TableViewLiaison, cell: UITableViewCell, indexPath: IndexPath)
    func perform(prefetchCommand: TableViewPrefetchCommand, for indexPath: IndexPath)
}
