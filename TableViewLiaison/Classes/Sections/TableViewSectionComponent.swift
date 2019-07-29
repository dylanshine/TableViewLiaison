//
//  TableViewSectionComponent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import Foundation

public struct TableViewSectionComponent<View: UITableViewHeaderFooterView>: AnyTableViewSectionComponent {

    public typealias CommandClosure = (TableViewLiaison, View, Int) -> Void

    private let registrationType: TableViewRegistrationType<View>
    private var commands = [TableViewSectionComponentCommand: CommandClosure]()
    private var heights = [TableViewHeightType: () -> CGFloat]()
    
    public init(commands: [TableViewSectionComponentCommand: CommandClosure] = [:],
                heights: [TableViewHeightType: () -> CGFloat] = [:],
                registrationType: TableViewRegistrationType<View> = .defaultClassType) {
        self.commands = commands
        self.heights = heights
        self.registrationType = registrationType
    }
    
    public func view(for liaison: TableViewLiaison, in section: Int) -> UITableViewHeaderFooterView? {
        let view = liaison.dequeue(View.self, with: reuseIdentifier)
        commands[.configuration]?(liaison, view, section)
        return view
    }
    
    public func register(with liaison: TableViewLiaison) {
        switch registrationType {
        case let .class(identifier):
            liaison.register(View.self, with: identifier)
        case let .nib(nib, identifier):
            liaison.registerHeaderFooterView(nib: nib, with: identifier)
        }
    }

    // MARK: - Commands
    public func perform(command: TableViewSectionComponentCommand, liaison: TableViewLiaison, view: UIView, section: Int) {
        guard let view = view as? View else { return }
        commands[command]?(liaison, view, section)
    }

    public mutating func set(command: TableViewSectionComponentCommand, with closure: @escaping CommandClosure) {
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


