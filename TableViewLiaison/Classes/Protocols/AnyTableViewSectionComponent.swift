//
//  AnyTableViewSectionComponent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import UIKit

public protocol AnyTableViewSectionComponent: TableViewContent {
    func perform(command: TableViewSectionComponentCommand, for view: UIView, in section: Int)
    func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView?
}
