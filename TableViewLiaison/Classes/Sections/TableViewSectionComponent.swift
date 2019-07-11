//
//  TableViewSectionComponent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import Foundation

public struct TableViewSectionComponent<View: UITableViewHeaderFooterView>: AnyTableViewSectionComponent {
    
    private let registrationType: TableViewRegistrationType<View>
    private var commands = [TableViewSectionComponentCommand: (View, Int) -> Void]()
    private var heights = [TableViewHeightType: () -> CGFloat]()
    
    public init(commands: [TableViewSectionComponentCommand: (View, Int) -> Void] = [:],
                heights: [TableViewHeightType: () -> CGFloat] = [:],
                registrationType: TableViewRegistrationType<View> = .defaultClassType) {
        self.commands = commands
        self.heights = heights
        self.registrationType = registrationType
    }
    
    public func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView? {
        let view = tableView.dequeue(View.self, with: reuseIdentifier)
        commands[.configuration]?(view, section)
        return view
    }
    
    public func register(with tableView: UITableView) {
        switch registrationType {
        case let .class(identifier):
            tableView.register(View.self, with: identifier)
        case let .nib(nib, identifier):
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    // MARK: - Commands
    public func perform(command: TableViewSectionComponentCommand, for view: UIView, in section: Int) {
        
        guard let view = view as? View else { return }
        
        commands[command]?(view, section)
    }
    
    public mutating func set(command: TableViewSectionComponentCommand, with closure: @escaping (View, Int) -> Void) {
        commands[command] = closure
    }
    
    public mutating func remove(command: TableViewSectionComponentCommand) {
        commands[command] = nil
    }
    
    public mutating func set(height: TableViewHeightType, _ closure: @escaping () -> CGFloat) {
        heights[height] = closure
    }
    
    public mutating func set(height: TableViewHeightType, _ value: CGFloat) {
        let closure: (() -> CGFloat) = { return value }
        heights[height] = closure
    }
    
    public mutating func remove(height: TableViewHeightType) {
        heights[height] = nil
    }
    
    // MARK: - Computed Properties
    public var height: CGFloat {
        return calculate(height: .height)
    }
    
    public var estimatedHeight: CGFloat {
        return calculate(height: .estimatedHeight)
    }
    
    public var reuseIdentifier: String {
        return registrationType.reuseIdentifier
    }
    
    // MARK: - Private
    private func calculate(height: TableViewHeightType) -> CGFloat {
        switch height {
        case .height:
            return heights[.height]?() ?? UITableView.automaticDimension
        case .estimatedHeight:
            return heights[.estimatedHeight]?() ?? heights[.height]?() ?? 0
        }
    }
}


