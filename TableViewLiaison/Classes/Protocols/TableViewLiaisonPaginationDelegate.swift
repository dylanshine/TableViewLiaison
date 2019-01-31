//
//  TableViewLiaisonPaginationDelegate.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 4/24/18.
//

import Foundation

public protocol TableViewLiaisonPaginationDelegate: AnyObject {
    func isPaginationEnabled() -> Bool
    func paginationStarted(indexPath: IndexPath)
    func paginationEnded(indexPath: IndexPath)
}
