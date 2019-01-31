//
//  TableViewRegistrationType.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public enum TableViewRegistrationType<T> {
    case nib(nib: UINib, reuseIdentifier: String)
    case `class`(reuseIdentifier: String)
    
    public static var defaultClassType: TableViewRegistrationType {
        return .class(reuseIdentifier: String(describing: T.self))
    }
    
    public static var defaultNibType: TableViewRegistrationType {
        return .nib(nib: UINib(nibName: String(describing: T.self), bundle: .main),
                    reuseIdentifier: String(describing: T.self))
    }
    
    var reuseIdentifier: String {
        switch self {
        case .class(let reuseIdentifier), .nib(_, let reuseIdentifier):
            return reuseIdentifier
        }
    }
}
