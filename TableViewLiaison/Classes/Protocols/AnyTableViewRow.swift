//
//  AnyTableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/24/18.
//

import UIKit

public protocol AnyTableViewRow: TableViewContent {
    var editable: Bool { get }
    var movable: Bool { get }
    var editActions: [UITableViewRowAction]? { get }
    var editingStyle: UITableViewCell.EditingStyle { get }
    var indentWhileEditing: Bool { get }
    var deleteConfirmationTitle: String? { get }
    var deleteRowAnimation: UITableView.RowAnimation { get }
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func perform(command: TableViewRowCommand, for cell: UITableViewCell, at indexPath: IndexPath)
    func perform(prefetchCommand: TableViewPrefetchCommand, for indexPath: IndexPath)
}
