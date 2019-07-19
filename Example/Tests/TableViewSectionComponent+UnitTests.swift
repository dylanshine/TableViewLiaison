//
//  TableViewSectionComponent+UnitTests.swift
//  OKTableViewLiaison_Tests
//
//  Created by Dylan Shine on 5/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import TableViewLiaison

final class OKTableViewSectionComponent_UnitTests: XCTestCase {
    var liaison: TableViewLiaison!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        liaison = TableViewLiaison()
        tableView = UITableView()
        liaison.liaise(tableView: tableView)
    }
    
    func test_setCommand_setsCommandClosure() {
        var component = TestTableViewSectionComponent()

        var set = false
        component.set(command: .configuration) { _, _, _ in
            set = true
        }
        
        component.perform(command: .configuration,
                          liaison: TableViewLiaison(),
                          view: UITableViewHeaderFooterView(),
                          section: 0)
        
        XCTAssertTrue(set)
    }
    
    func test_removeCommand_removesCommand() {
        var component = TestTableViewSectionComponent()

        var set = false
        component.set(command: .configuration) { _, _, _ in
            set = true
        }
        
        component.remove(command: .configuration)
        component.perform(command: .configuration,
                          liaison: TableViewLiaison(),
                          view: UITableViewHeaderFooterView(),
                          section: 0)

        XCTAssertFalse(set)
    }
    
    func test_setHeight_setsHeightWithClosure() {
        var component = TestTableViewSectionComponent()

        component.set(height: .height) { return 100 }
       
        component.set(height: .estimatedHeight) { return 150 }
        
        XCTAssertEqual(component.height, 100)
        XCTAssertEqual(component.estimatedHeight, 150)
    }
    
    func test_setHeight_setsHeightWithValue() {
        var component = TestTableViewSectionComponent()

        component.set(height: .height, 100)
        component.set(height: .estimatedHeight, 105)
        
        XCTAssertEqual(component.height, 100)
        XCTAssertEqual(component.estimatedHeight, 105)
    }
    
    func test_setHeight_returnsAutomaticDimensionForSelfSizingView() {
        let component = TestTableViewSectionComponent()
        XCTAssertEqual(component.height, UITableView.automaticDimension)
        XCTAssertEqual(component.estimatedHeight, 0)
    }
    
    func test_removeHeight_removesAPreviouslySetHeight() {
        var component = TestTableViewSectionComponent()

        component.set(height: .height, 100)
        component.set(height: .estimatedHeight, 100)
        component.remove(height: .height)
        component.remove(height: .estimatedHeight)

        XCTAssertEqual(component.height, UITableView.automaticDimension)
        XCTAssertEqual(component.estimatedHeight, 0)
    }
    
    func test_estimatedHeight_estimatedHeightReturnsHeightIfHeightIsSetAndEstimatedHeightIsNot() {
        var component = TestTableViewSectionComponent()
        component.set(height: .height, 100)
        
        XCTAssertEqual(component.estimatedHeight, 100)
    }
    
    func test_register_registersViewForSectionComponent() {
        let component = TestTableViewSectionComponent(registrationType: .class(reuseIdentifier: "Test"))
        
        component.register(with: liaison)
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Test")
        
        XCTAssertNotNil(view)
    }

    func test_viewForTableViewInSection_returnsConfiguredViewForComponent() {
        
        var component = TestTableViewSectionComponent()
        let string = "Test"
        component.set(command: .configuration) { _, view, _ in
            view.accessibilityIdentifier = string
        }
        
        component.register(with: liaison)
        
        let view = component.view(for: liaison, in: 0)
        
        XCTAssertEqual(view?.accessibilityIdentifier, string)
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectViewType() {
        var component = TestTableViewSectionComponent()
        var configured = false
        
        component.set(command: .configuration) { _, _, _ in
            configured = true
        }
        
        component.perform(command: .configuration, liaison: liaison, view: UIView(), section: 0)
        
        XCTAssertFalse(configured)
    }
    
    func test_reuseIdentifier_returnsCorrectReuseIdentifierForRegistrationType() {
        let component1 = TestTableViewSectionComponent(registrationType: .defaultClassType)
        let component2 = TestTableViewSectionComponent()
        let component3 = TestTableViewSectionComponent(registrationType: .class(reuseIdentifier: "Test"))
        
        XCTAssertEqual(component1.reuseIdentifier, String(describing: UITableViewHeaderFooterView.self))
        XCTAssertEqual(component2.reuseIdentifier, String(describing: UITableViewHeaderFooterView.self))
        XCTAssertEqual(component3.reuseIdentifier, "Test")
    }
}
