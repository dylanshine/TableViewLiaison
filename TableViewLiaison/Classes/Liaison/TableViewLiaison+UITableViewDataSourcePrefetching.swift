//
//  TableViewLiaison+PF.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/24/18.
//

import UIKit

extension TableViewLiaison: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            row(for: $0)?.perform(prefetchCommand: .prefetch, for: $0)
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            row(for: $0)?.perform(prefetchCommand: .cancel, for: $0)
        }
    }
}
