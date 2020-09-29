//
//  TableViewRow.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 9/29/20.
//

import UIKit


public extension TableViewRow where Data == Void {
    typealias StatelessCommandClosure = (TableViewLiaison, Cell, IndexPath) -> Void
    typealias StatelessPrefetchCommandClosure = (IndexPath) -> Void

    init(_ cellType: Cell.Type,
         prefetchCommands: [TableViewPrefetchCommand: PrefetchCommandClosure] = [:],
         commands: [TableViewRowCommand: CommandClosure] = [:],
         heights: [TableViewHeightType: () -> CGFloat] = [:],
         editingStyle: UITableViewCell.EditingStyle = .none,
         movable: Bool = false,
         editActions: [UITableViewRowAction]? = nil,
         indentWhileEditing: Bool = false,
         deleteConfirmationTitle: String? = nil,
         deleteRowAnimation: UITableView.RowAnimation = .automatic,
         registrationType: TableViewRegistrationType<Cell> = .defaultClassType) {
        
        self.init(cellType,
                  data: (),
                  prefetchCommands: prefetchCommands,
                  commands: commands,
                  heights: heights,
                  editingStyle: editingStyle,
                  movable: movable,
                  editActions: editActions,
                  indentWhileEditing: indentWhileEditing,
                  deleteConfirmationTitle: deleteConfirmationTitle,
                  deleteRowAnimation: deleteRowAnimation,
                  registrationType: registrationType)
    }
    
    mutating func set(_ command: TableViewRowCommand, with closure: @escaping StatelessCommandClosure) {
        commands[command] = { liaison, cell, _, indexPath in closure(liaison, cell, indexPath) }
    }
    
    mutating func set(_ prefetchCommand: TableViewPrefetchCommand, with closure: @escaping StatelessPrefetchCommandClosure) {
        prefetchCommands[prefetchCommand] = {_, indexPath in closure(indexPath) }
    }
}

public extension TableViewRow where Cell == UITableViewCell {
    init(data: Data,
         prefetchCommands: [TableViewPrefetchCommand: PrefetchCommandClosure] = [:],
         commands: [TableViewRowCommand: CommandClosure] = [:],
         heights: [TableViewHeightType: () -> CGFloat] = [:],
         editingStyle: UITableViewCell.EditingStyle = .none,
         movable: Bool = false,
         editActions: [UITableViewRowAction]? = nil,
         indentWhileEditing: Bool = false,
         deleteConfirmationTitle: String? = nil,
         deleteRowAnimation: UITableView.RowAnimation = .automatic,
         registrationType: TableViewRegistrationType<Cell> = .defaultClassType) {
        
        self.init(UITableViewCell.self,
                  data: data,
                  prefetchCommands: prefetchCommands,
                  commands: commands,
                  heights: heights,
                  editingStyle: editingStyle,
                  movable: movable,
                  editActions: editActions,
                  indentWhileEditing: indentWhileEditing,
                  deleteConfirmationTitle: deleteConfirmationTitle,
                  deleteRowAnimation: deleteRowAnimation,
                  registrationType: registrationType)
    }
}

public extension TableViewRow where Cell == UITableViewCell, Data == Void {
    init(prefetchCommands: [TableViewPrefetchCommand: PrefetchCommandClosure] = [:],
         commands: [TableViewRowCommand: CommandClosure] = [:],
         heights: [TableViewHeightType: () -> CGFloat] = [:],
         editingStyle: UITableViewCell.EditingStyle = .none,
         movable: Bool = false,
         editActions: [UITableViewRowAction]? = nil,
         indentWhileEditing: Bool = false,
         deleteConfirmationTitle: String? = nil,
         deleteRowAnimation: UITableView.RowAnimation = .automatic,
         registrationType: TableViewRegistrationType<Cell> = .defaultClassType) {
        
        self.init(UITableViewCell.self,
                  data: (),
                  prefetchCommands: prefetchCommands,
                  commands: commands,
                  heights: heights,
                  editingStyle: editingStyle,
                  movable: movable,
                  editActions: editActions,
                  indentWhileEditing: indentWhileEditing,
                  deleteConfirmationTitle: deleteConfirmationTitle,
                  deleteRowAnimation: deleteRowAnimation,
                  registrationType: registrationType)
    }
}
