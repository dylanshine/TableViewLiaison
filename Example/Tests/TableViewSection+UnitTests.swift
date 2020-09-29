//
//  TableViewSection+UnitTests.swift
//  TableViewLiaisonTests
//
//  Created by Dylan Shine on 3/26/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import XCTest
@testable import TableViewLiaison

final class TableViewSection_UnitTests: XCTestCase {
    
    var liaison: TableViewLiaison!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        liaison = TableViewLiaison()
        tableView = UITableView()
        liaison.liaise(tableView: tableView)
    }
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithClosure() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(.height) { return 100 }
        
        footer.set(.height) { return 50 }
        
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(.height, for: .header), 100)
        XCTAssertEqual(section.calculate(.height, for: .footer), 50)
    }
    
    func test_calculateEstimatedHeight_setsEstimatedHeightOfSupplementaryViewsWithClosure() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(.estimatedHeight) { return 100 }
        
        footer.set(.estimatedHeight) { return 50 }
        
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .header), 100)
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .footer), 50)
    }
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithValue() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(.height, 100)
        footer.set(.height, 50)
        
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(.height, for: .header), 100)
        XCTAssertEqual(section.calculate(.height, for: .footer), 50)
    }
    
    func test_calculateEstimatedHeight_setsEstimatedHeightOfSupplementaryViewsWithValue() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(.estimatedHeight, 100)
        footer.set(.estimatedHeight, 50)
        
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .header), 100)
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .footer), 50)
    }
    
    func test_calculateHeight_returnsAutomaticDimensionForSelfSizingSupplementaryViews() {
        let section = TableViewSection(option: .both(headerComponent: TestTableViewSectionComponent(),
                                                                         footerComponent: TestTableViewSectionComponent()))
        
        XCTAssertEqual(section.calculate(.height, for: .header), UITableView.automaticDimension)
        XCTAssertEqual(section.calculate(.height, for: .footer), UITableView.automaticDimension)
    }
    
    func test_calculateHeight_returnsZeroForNonSetEstimatedSupplementaryViewsHeights() {
        let section = TableViewSection(option: .both(headerComponent: TestTableViewSectionComponent(),
                                                                       footerComponent: TestTableViewSectionComponent()))
        
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .header), 0)
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .footer), 0)
    }
    
    func test_calculateHeight_returnZeroForHeightOfNonDisplayedSupplementaryViews() {
        let section = TableViewSection()
        
        let headerHeight = section.calculate(.height, for: .header)
        let footerHeight = section.calculate(.height, for: .footer)
        let headerEstimatedHeight = section.calculate(.estimatedHeight, for: .header)
        let footerEstimatedHeight = section.calculate(.estimatedHeight, for: .footer)
        
        if #available(iOS 11.0, *) {
            XCTAssertEqual(headerHeight, .leastNormalMagnitude)
            XCTAssertEqual(footerHeight, .leastNormalMagnitude)
            XCTAssertEqual(headerEstimatedHeight, .leastNormalMagnitude)
            XCTAssertEqual(footerEstimatedHeight, .leastNormalMagnitude)
        } else {
            XCTAssertEqual(headerHeight, 0)
            XCTAssertEqual(footerHeight, 0)
            XCTAssertEqual(headerEstimatedHeight, 0)
            XCTAssertEqual(footerEstimatedHeight, 0)
        }
    }
    
    func test_removeHeight_removesHeightOfSupplementaryViews() {
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(.height, 40)
        footer.set(.height, 40)
        header.set(.estimatedHeight, 40)
        footer.set(.estimatedHeight, 40)
        
        header.remove(.height)
        footer.remove(.height)
        header.remove(.estimatedHeight)
        footer.remove(.estimatedHeight)
        
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))

        XCTAssertEqual(section.calculate(.height, for: .header), UITableView.automaticDimension)
        XCTAssertEqual(section.calculate(.height, for: .footer), UITableView.automaticDimension)
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .header), 0)
        XCTAssertEqual(section.calculate(.estimatedHeight, for: .footer), 0)
    }
    
    func test_appendRows_appendsNewRowsToSection() {
        var section = TableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        XCTAssertEqual(section.rows.count, 0)
    
        section.append(rows: [row1, row2])
        
        XCTAssertEqual(section.rows.count, 2)
    }
    
    func test_appendRow_appendsRowToSection() {
        var section = TableViewSection()
        let row = TestTableViewRow()
        
        XCTAssertEqual(section.rows.count, 0)
        
        section.append(row: row)
        
        XCTAssertEqual(section.rows.count, 1)
    }
    
    func test_headerForTableView_returnsConfiguredHeaderForSection() {
        let liaison = TableViewLiaison()
        let tableView = UITableView()
        liaison.liaise(tableView: tableView)
        
        var header = TestTableViewSectionComponent()
        
        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        header.set(.configuration) { _, view, _ in
            view.accessibilityIdentifier = string
        }
        
        let section = TableViewSection(option: .header(component: header))
        
        let headerView = section.view(componentView: .header, for: liaison, in: 0)
        
        XCTAssertEqual(headerView?.accessibilityIdentifier, string)
        XCTAssert(headerView is UITableViewHeaderFooterView)
    }
    
    func test_footerForTableView_returnsConfiguredFooterForSection() {
        var footer = TestTableViewSectionComponent()

        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        footer.set(.configuration) { _, view, _ in
            view.accessibilityIdentifier = string
        }
        
        let section = TableViewSection(option: .footer(component: footer))

        let footerView = section.view(componentView: .footer, for: liaison, in: 0)
        
        XCTAssertEqual(footerView?.accessibilityIdentifier, string)
        XCTAssert(footerView is UITableViewHeaderFooterView)
    }
    
    func test_perform_performsSectionCommands() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        var headerConfiguration = ""
        var headerDidEndDisplaying = ""
        var headerWillDisplay = ""
        var footerConfiguration = ""
        var footerDidEndDisplaying = ""
        var footerWillDisplay = ""
        
        header.set(.configuration) { _, view, section in
            headerConfiguration = "Configured!"
        }
        
        header.set(.didEndDisplaying) { _, view, section in
            headerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        header.set(.willDisplay) { _, view, section in
            headerWillDisplay = "WillDisplay!"
        }
        
        footer.set(.configuration) { _, view, section in
            footerConfiguration = "Configured!"
        }
        
        footer.set(.didEndDisplaying) { _, view, section in
            footerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        footer.set(.willDisplay) { _, view, section in
            footerWillDisplay = "WillDisplay!"
        }
        
        let view = UITableViewHeaderFooterView()
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))
        
        section.perform(.configuration, componentView: .header, liaison: liaison, view: view, section: 0)
        section.perform(.configuration, componentView: .footer, liaison: liaison, view: view, section: 0)
        section.perform(.didEndDisplaying, componentView: .header, liaison: liaison, view: view, section: 0)
        section.perform(.didEndDisplaying, componentView: .footer, liaison: liaison, view: view, section: 0)
        section.perform(.willDisplay, componentView: .header, liaison: liaison, view: view, section: 0)
        section.perform(.willDisplay, componentView: .footer, liaison: liaison, view: view, section: 0)
        
        XCTAssertEqual(headerConfiguration, "Configured!")
        XCTAssertEqual(footerConfiguration, "Configured!")
        XCTAssertEqual(headerDidEndDisplaying, "DidEndDisplaying!")
        XCTAssertEqual(footerDidEndDisplaying, "DidEndDisplaying!")
        XCTAssertEqual(headerWillDisplay, "WillDisplay!")
        XCTAssertEqual(footerWillDisplay, "WillDisplay!")
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectSupplementaryViewType() {
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()

        var headerConfiguration = ""
        var footerConfiguration = ""
        
        header.set(.configuration) { _, view, section in
            headerConfiguration = "Configured!"
        }
        
        footer.set(.configuration) { _, view, section in
            footerConfiguration = "Configured!"
        }
        
        let view = UIView()
        
        let section = TableViewSection(option: .both(headerComponent: header, footerComponent: footer))
        section.perform(.configuration, componentView: .header, liaison: liaison, view: view, section: 0)
        section.perform(.configuration, componentView: .footer, liaison: liaison, view: view, section: 0)
        
        XCTAssertEqual(headerConfiguration, "")
        XCTAssertEqual(footerConfiguration, "")
    }
    
    func test_rowIndexPaths_returnsIndexPathsForPredicate() {
        let row1 = TableViewRow(data: "test")
        let row2 = TestTableViewRow()
        let row3 = TableViewRow(data: "test")
        
        let section = TableViewSection(rows: [row1, row2, row3])
        
        let indexPaths = section.rowIndexPaths(for: 0) { (data: String) in
            return data == "test"
        }
        
        XCTAssertEqual(indexPaths, [IndexPath(row: 0, section: 0),
                                    IndexPath(row: 2, section: 0)])
    }
    
}
