//
//  TableViewSectionComponent.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import Foundation

open class TableViewSectionComponent<View: UITableViewHeaderFooterView, Model>: AnyTableViewSectionComponent {
    
    public let model: Model
    
    private let registrationType: TableViewRegistrationType<View>
    private var commands = [TableViewSectionComponentCommand: (View, Model, Int) -> Void]()
    private var heights = [TableViewHeightType: (Model) -> CGFloat]()
    
    public init(_ model: Model, registrationType: TableViewRegistrationType<View> = .defaultClassType) {
        self.model = model
        self.registrationType = registrationType
    }
    
    public func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView? {
        let view = tableView.dequeue(View.self, with: reuseIdentifier)
        commands[.configuration]?(view, model, section)
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
        
        commands[command]?(view, model, section)
    }
    
    public func set(command: TableViewSectionComponentCommand, with closure: @escaping (View, Model, Int) -> Void) {
        commands[command] = closure
    }
    
    public func remove(command: TableViewSectionComponentCommand) {
        commands[command] = nil
    }
    
    public func set(height: TableViewHeightType, _ closure: @escaping (Model) -> CGFloat) {
        heights[height] = closure
    }
    
    public func set(height: TableViewHeightType, _ value: CGFloat) {
        let closure: ((Model) -> CGFloat) = { _ -> CGFloat in return value }
        heights[height] = closure
    }
    
    public func remove(height: TableViewHeightType) {
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
            return heights[.height]?(model) ?? UITableView.automaticDimension
        case .estimatedHeight:
            return heights[.estimatedHeight]?(model) ?? heights[.height]?(model) ?? 0
        }
    }
}

public extension TableViewSectionComponent where Model == Void {
    
    convenience init(registrationType: TableViewRegistrationType<View> = .defaultClassType) {
        self.init((),
                  registrationType: registrationType)
    }
}

