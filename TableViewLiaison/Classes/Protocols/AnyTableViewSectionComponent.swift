//
//  AnyTableViewSectionComponent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import UIKit

public protocol AnyTableViewSectionComponent: TableViewContent {
    func perform(command: TableViewSectionComponentCommand, liaison: TableViewLiaison, view: UIView, section: Int)
    func view(for liaison: TableViewLiaison, in section: Int) -> UITableViewHeaderFooterView?
}
