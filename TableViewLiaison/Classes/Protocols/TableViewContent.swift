//
//  TableViewContent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 9/4/18.
//

import UIKit

public protocol TableViewContent: AnyObject {
    var height: CGFloat { get }
    var estimatedHeight: CGFloat { get }
    var reuseIdentifier: String { get }
    func register(with tableView: UITableView)
}
