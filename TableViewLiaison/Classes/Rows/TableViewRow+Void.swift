//
//  TableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 9/29/20.
//

import UIKit

public typealias StatelessTableViewRow<Cell: UITableViewCell> = TableViewRow<Cell, Void>

public extension TableViewRow where Data == Void {
    typealias StatelessHeightClosure = () -> CGFloat
    typealias StatelessCommandClosure = (TableViewLiaison, Cell, IndexPath) -> Void
    typealias StatelessPrefetchCommandClosure = (IndexPath) -> Void
    
    init(prefetchCommands: [TableViewPrefetchCommand: StatelessPrefetchCommandClosure] = [:],
         commands: [TableViewRowCommand: StatelessCommandClosure] = [:],
         heights: [TableViewHeightType: StatelessHeightClosure] = [:],
         editingStyle: UITableViewCell.EditingStyle = .none,
         movable: Bool = false,
         editActions: [UITableViewRowAction]? = nil,
         indentWhileEditing: Bool = false,
         deleteConfirmationTitle: String? = nil,
         deleteRowAnimation: UITableView.RowAnimation = .automatic,
         registrationType: TableViewRegistrationType<Cell> = .defaultClassType) {
        
        var _heights = [TableViewHeightType: (Data) -> CGFloat]()
        var _prefetchCommands = [TableViewPrefetchCommand: PrefetchCommandClosure]()
        var _commands = [TableViewRowCommand: CommandClosure]()
        
        heights.forEach { (key: TableViewHeightType, value: @escaping StatelessHeightClosure) in
            _heights[key] = { _ in value() }
        }
        
        prefetchCommands.forEach { (key: TableViewPrefetchCommand, value: @escaping StatelessPrefetchCommandClosure) in
            _prefetchCommands[key] = { _, indexPath in value(indexPath) }
        }
        
        commands.forEach { (key: TableViewRowCommand, value: @escaping StatelessCommandClosure) in
            _commands[key] = { liaison, cell, _, indexPath in value(liaison, cell, indexPath) }
        }
        
        self.init((),
                  prefetchCommands: _prefetchCommands,
                  commands: _commands,
                  heights: _heights,
                  editingStyle: editingStyle,
                  movable: movable,
                  editActions: editActions,
                  indentWhileEditing: indentWhileEditing,
                  deleteConfirmationTitle: deleteConfirmationTitle,
                  deleteRowAnimation: deleteRowAnimation,
                  registrationType: registrationType)
    }
    
    mutating func set(_ height: TableViewHeightType, _ closure: @escaping () -> CGFloat) {
        heights[height] = { _ in  closure() }
    }
    
    mutating func set(_ command: TableViewRowCommand, with closure: @escaping StatelessCommandClosure) {
        commands[command] = { liaison, cell, _, indexPath in closure(liaison, cell, indexPath) }
    }
    
    mutating func set(_ prefetchCommand: TableViewPrefetchCommand, with closure: @escaping StatelessPrefetchCommandClosure) {
        prefetchCommands[prefetchCommand] = {_, indexPath in closure(indexPath) }
    }
}
