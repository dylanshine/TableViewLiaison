//
//  TableViewSectionComponentDisplayOption.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

public enum TableViewSectionComponentDisplayOption {
    case none
    case header(component: AnyTableViewSectionComponent)
    case footer(component: AnyTableViewSectionComponent)
    case both(headerComponent: AnyTableViewSectionComponent, footerComponent: AnyTableViewSectionComponent)
    
    public var header: AnyTableViewSectionComponent? {
        switch self {
        case .header(let header):
            return header
        case .both(let header, _):
            return header
        default:
            return nil
        }
    }
    
    public var footer: AnyTableViewSectionComponent? {
        switch self {
        case .footer(let footer):
            return footer
        case .both(_, let footer):
            return footer
        default:
            return nil
        }
    }
}
