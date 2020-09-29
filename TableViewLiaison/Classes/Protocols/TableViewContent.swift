//
//  TableViewContent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 9/4/18.
//

import UIKit

public protocol TableViewContent {
    var reuseIdentifier: String { get }
    func register(with liaison: TableViewLiaison)
    func calculate(height: TableViewHeightType) -> CGFloat
}

extension TableViewContent {
    public var height: CGFloat {
        return calculate(height: .height)
    }
    
    public var estimatedHeight: CGFloat {
        return calculate(height: .estimatedHeight)
    }
}
