//
//  TableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public struct TableViewRow<Cell: UITableViewCell>: AnyTableViewRow {
    
    public let id: String?
    public var editingStyle: UITableViewCell.EditingStyle
    public var movable: Bool
    public var editActions: [UITableViewRowAction]?
    public var indentWhileEditing: Bool
    public var deleteConfirmationTitle: String?
    public var deleteRowAnimation: UITableView.RowAnimation
    
    private let registrationType: TableViewRegistrationType<Cell>
    private var commands = [TableViewRowCommand: (TableViewLiaison, Cell, IndexPath) -> Void]()
    private var prefetchCommands = [TableViewPrefetchCommand: (IndexPath) -> Void]()
    private var heights = [TableViewHeightType: () -> CGFloat]()
    
    public init(id: String? = nil,
                commands: [TableViewRowCommand: (TableViewLiaison, Cell, IndexPath) -> Void] = [:],
                prefetchCommands: [TableViewPrefetchCommand: (IndexPath) -> Void] = [:],
                heights: [TableViewHeightType: () -> CGFloat] = [:],
                editingStyle: UITableViewCell.EditingStyle = .none,
                movable: Bool = false,
                editActions: [UITableViewRowAction]? = nil,
                indentWhileEditing: Bool = false,
                deleteConfirmationTitle: String? = nil,
                deleteRowAnimation: UITableView.RowAnimation = .automatic,
                registrationType: TableViewRegistrationType<Cell> = .defaultClassType) {
        self.id = id
        self.commands = commands
        self.prefetchCommands = prefetchCommands
        self.heights = heights
        self.editingStyle = editingStyle
        self.movable = movable
        self.editActions = editActions
        self.indentWhileEditing = indentWhileEditing
        self.deleteConfirmationTitle = deleteConfirmationTitle
        self.deleteRowAnimation = deleteRowAnimation
        self.registrationType = registrationType
    }
    
    // MARK: - Cell
    public func cell(for liaison: TableViewLiaison, at indexPath: IndexPath) -> UITableViewCell {
        let cell = liaison.dequeue(Cell.self, with: reuseIdentifier)
        commands[.configuration]?(liaison, cell, indexPath)
        return cell
    }
    
    public func register(with liaison: TableViewLiaison) {
        switch registrationType {
        case let .class(identifier):
            liaison.register(Cell.self, with: identifier)
        case let .nib(nib, identifier):
            liaison.registerCell(nib: nib, with: identifier)
        }
    }
    
    // MARK: - Commands
    public func perform(command: TableViewRowCommand, liaison: TableViewLiaison, cell: UITableViewCell, indexPath: IndexPath) {
        
        guard let cell = cell as? Cell else { return }
        
        commands[command]?(liaison, cell, indexPath)
    }
    
    public func perform(prefetchCommand: TableViewPrefetchCommand, for indexPath: IndexPath) {
        prefetchCommands[prefetchCommand]?(indexPath)
    }
    
    public mutating func set(command: TableViewRowCommand, with closure: @escaping (TableViewLiaison, Cell, IndexPath) -> Void) {
        commands[command] = closure
    }
    
    public mutating func remove(command: TableViewRowCommand) {
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
    
    public mutating func set(prefetchCommand: TableViewPrefetchCommand, with closure: @escaping (IndexPath) -> Void) {
        prefetchCommands[prefetchCommand] = closure
    }
    
    public mutating func remove(prefetchCommand: TableViewPrefetchCommand) {
        prefetchCommands[prefetchCommand] = nil
    }
    
    // MARK: - Computed Properties
    public var height: CGFloat {
        return calculate(height: .height)
    }
    
    public var estimatedHeight: CGFloat {
        return calculate(height: .estimatedHeight)
    }
    
    public var editable: Bool {
        return editingStyle != .none || editActions?.isEmpty == false
    }
    
    public var reuseIdentifier: String {
        return registrationType.reuseIdentifier
    }

    // MARK: - Private
    
    private func calculate(height: TableViewHeightType) -> CGFloat {
        return heights[height]?() ?? UITableView.automaticDimension
    }
}
