//
//  TableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public struct TableViewRow<Cell: UITableViewCell, Data>: AnyTableViewRow {
    
    public typealias PrefetchCommandClosure = (Data, IndexPath) -> Void
    public typealias CommandClosure = (TableViewLiaison, Cell, Data, IndexPath) -> Void
    
    public let data: Data
    public var editingStyle: UITableViewCell.EditingStyle
    public var movable: Bool
    public var editActions: [UITableViewRowAction]?
    public var indentWhileEditing: Bool
    public var deleteConfirmationTitle: String?
    public var deleteRowAnimation: UITableView.RowAnimation
    public let registrationType: TableViewRegistrationType<Cell>
    public internal(set) var prefetchCommands = [TableViewPrefetchCommand: PrefetchCommandClosure]()
    public internal(set) var commands = [TableViewRowCommand: CommandClosure]()
    public internal(set) var heights = [TableViewHeightType: (Data) -> CGFloat]()

    public init(_ data: Data,
                prefetchCommands: [TableViewPrefetchCommand: PrefetchCommandClosure] = [:],
                commands: [TableViewRowCommand: CommandClosure] = [:],
                heights: [TableViewHeightType: (Data) -> CGFloat] = [:],
                editingStyle: UITableViewCell.EditingStyle = .none,
                movable: Bool = false,
                editActions: [UITableViewRowAction]? = nil,
                indentWhileEditing: Bool = false,
                deleteConfirmationTitle: String? = nil,
                deleteRowAnimation: UITableView.RowAnimation = .automatic,
                registrationType: TableViewRegistrationType<Cell> = .defaultClassType) {
        
        self.data = data
        self.prefetchCommands = prefetchCommands
        self.commands = commands
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
        commands[.configuration]?(liaison, cell, data, indexPath)
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
    public func perform(_ command: TableViewRowCommand, liaison: TableViewLiaison, cell: UITableViewCell, indexPath: IndexPath) {
        
        guard let cell = cell as? Cell else { return }
        
        commands[command]?(liaison, cell, data, indexPath)
    }
    
    public func perform(_ prefetchCommand: TableViewPrefetchCommand, for indexPath: IndexPath) {
        prefetchCommands[prefetchCommand]?(data, indexPath)
    }
    
    public mutating func set(_ command: TableViewRowCommand, with closure: @escaping CommandClosure) {
        commands[command] = closure
    }
    
    public mutating func remove(_ command: TableViewRowCommand) {
        commands[command] = nil
    }
    
    public mutating func set(_ height: TableViewHeightType, _ closure: @escaping (Data) -> CGFloat) {
        heights[height] = closure
    }
    
    public mutating func set(_ height: TableViewHeightType, _ value: CGFloat) {
        let closure: ((Data) -> CGFloat) = { _ in return value }
        heights[height] = closure
    }
    
    public mutating func remove(_ height: TableViewHeightType) {
        heights[height] = nil
    }
    
    public mutating func set(_ prefetchCommand: TableViewPrefetchCommand, with closure: @escaping PrefetchCommandClosure) {
        prefetchCommands[prefetchCommand] = closure
    }
    
    public mutating func remove(_ prefetchCommand: TableViewPrefetchCommand) {
        prefetchCommands[prefetchCommand] = nil
    }
    
    public func calculate(_ height: TableViewHeightType) -> CGFloat {
        return heights[height]?(data) ?? UITableView.automaticDimension
    }
    
    // MARK: - Computed Properties
    
    public var _data: Any? {
        return data
    }

    public var editable: Bool {
        return editingStyle != .none || editActions?.isEmpty == false
    }
    
    public var reuseIdentifier: String {
        return registrationType.reuseIdentifier
    }
  
}
