//
//  TableViewRow+UnitTests.swift
//  TableViewLiaisonTests
//
//  Created by Dylan Shine on 3/27/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import XCTest
@testable import TableViewLiaison

final class TableViewRow_UnitTests: XCTestCase {
    
    var liaison: TableViewLiaison!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        liaison = TableViewLiaison()
        tableView = UITableView()
        liaison.liaise(tableView: tableView)
    }
    
    func test_setCommand_setsCommandClosure() {
        var row = TestTableViewRow()
        
        var set = false
        row.set(.configuration) { _, _, _ in
            set = true
        }
       
        row.perform(.configuration, liaison: liaison, cell: UITableViewCell(), indexPath: IndexPath())
        
        XCTAssertTrue(set)
    }
    
    func test_removeCommand_removesCommand() {
        var row = TestTableViewRow()
        
        var set = false
        row.set(.configuration) { _, _, _ in
            set = true
        }
        
        row.remove(.configuration)
        row.perform(.configuration, liaison: liaison, cell: UITableViewCell(), indexPath: IndexPath())

        XCTAssertFalse(set)
    }
    
    func test_setHeight_setsHeightWithClosure() {
        var row = TestTableViewRow()

        row.set(height: .height) { return 100 }
        
        XCTAssertEqual(row.height, 100)
    }
    
    func test_setHeight_setsHeightWithValue() {
        var row = TestTableViewRow()
        
        row.set(height: .height, 100)
        
        XCTAssertEqual(row.height, 100)
    }
    
    func test_setHeight_returnsAutomaticDimensionForSelfSizingRow() {
        let row = TestTableViewRow()
        XCTAssertEqual(row.height, UITableView.automaticDimension)
        XCTAssertEqual(row.estimatedHeight, UITableView.automaticDimension)
    }
    
    func test_removeHeight_removesAPreviouslySetHeight() {
        var row = TestTableViewRow()
        
        row.set(height: .height, 100)
        row.set(height: .estimatedHeight, 100)
        
        row.remove(height: .height)
        row.remove(height: .estimatedHeight)
        
        XCTAssertEqual(row.height, UITableView.automaticDimension)
        XCTAssertEqual(row.estimatedHeight, UITableView.automaticDimension)
    }
    
    func test_setPrefetchCommand_setPrefetchCommandClosure() {
        var row = TestTableViewRow()
        
        var prefetch = false
        row.set(.prefetch) { _ in
            prefetch = true
        }
        
        var cancel = false
        row.set(.cancel) { _ in
            cancel = true
        }
        
        row.perform(.prefetch, for: IndexPath())
        row.perform(.cancel, for: IndexPath())

        XCTAssertTrue(prefetch)
        XCTAssertTrue(cancel)
    }
    
    func test_removePrefetchCommand_removesPreviouslySetPrefetchCommands() {
        var row = TestTableViewRow()
        
        var prefetch = false
        row.set(.prefetch) { _ in
            prefetch = true
        }
        
        var cancel = false
        row.set(.cancel) { _ in
            cancel = true
        }
        
        row.remove(.prefetch)
        row.remove(.cancel)
        
        row.perform(.prefetch, for: IndexPath())
        row.perform(.cancel, for: IndexPath())
        
        XCTAssertFalse(prefetch)
        XCTAssertFalse(cancel)
    }
    
    func test_editable_returnsIfRowIsEditable() {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Action", handler: { (action, indexPath) in
            print("This action is being invoked")
        })
        
        let row1 = TestTableViewRow(editingStyle: .delete)
        let row2 = TestTableViewRow(editingStyle: .insert)
        let row3 = TestTableViewRow(editActions: [editAction])
        let row4 = TestTableViewRow()
        
        XCTAssertTrue(row1.editable)
        XCTAssertTrue(row2.editable)
        XCTAssertTrue(row3.editable)
        XCTAssertFalse(row4.editable)
    }
    
    func test_reuseIdentifier_returnsCorrectReuseIdentifierForRegistrationType() {
        let row1 = TestTableViewRow(registrationType: .defaultClassType)
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow(registrationType: .class(reuseIdentifier: "Test"))
        
        XCTAssertEqual(row1.reuseIdentifier, String(describing: UITableViewCell.self))
        XCTAssertEqual(row2.reuseIdentifier, String(describing: UITableViewCell.self))
        XCTAssertEqual(row3.reuseIdentifier, "Test")
    }
    
    func test_register_registersCellForRow() {
        let row = TestTableViewRow(registrationType: .class(reuseIdentifier: "Test"))
        
        row.register(with: liaison)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test")
        
        XCTAssertNotNil(cell)
    }
    
    func test_cellForTableViewAt_returnsConfiguredCellForRow() {
        var row = TestTableViewRow()
        let string = "Test"
        row.set(.configuration) { _, cell, indexPath in
            cell.accessibilityIdentifier = string
        }
                
        row.register(with: liaison)
        
        let cell = row.cell(for: liaison, at: IndexPath())
        
        XCTAssertEqual(cell.accessibilityIdentifier, string)
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectCellType() {
        var row = TableViewRow<TestTableViewCell>()
        var configured = false
        
        row.set(.configuration) { _, _, _ in
            configured = true
        }
            
        row.perform(.configuration, liaison: liaison, cell: UITableViewCell(), indexPath: IndexPath())
        
        XCTAssertFalse(configured)
    }

}
