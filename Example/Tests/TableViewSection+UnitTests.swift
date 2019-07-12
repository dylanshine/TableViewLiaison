//
//  TableViewSection+UnitTests.swift
//  TableViewLiaisonTests
//
//  Created by Dylan Shine on 3/26/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import XCTest
@testable import TableViewLiaison

final class OKTableViewSection_UnitTests: XCTestCase {
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithClosure() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(height: .height) { return 100 }
        
        footer.set(height: .height) { return 50 }
        
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(height: .height, for: .header), 100)
        XCTAssertEqual(section.calculate(height: .height, for: .footer), 50)
    }
    
    func test_calculateEstimatedHeight_setsEstimatedHeightOfSupplementaryViewsWithClosure() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(height: .estimatedHeight) { return 100 }
        
        footer.set(height: .estimatedHeight) { return 50 }
        
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .header), 100)
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .footer), 50)
    }
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithValue() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(height: .height, 100)
        footer.set(height: .height, 50)
        
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(height: .height, for: .header), 100)
        XCTAssertEqual(section.calculate(height: .height, for: .footer), 50)
    }
    
    func test_calculateEstimatedHeight_setsEstimatedHeightOfSupplementaryViewsWithValue() {
        
        var header = TestTableViewSectionComponent()
        var footer = TestTableViewSectionComponent()
        
        header.set(height: .estimatedHeight, 100)
        footer.set(height: .estimatedHeight, 50)
        
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .header), 100)
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .footer), 50)
    }
    
    func test_calculateHeight_returnsAutomaticDimensionForSelfSizingSupplementaryViews() {
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: TestTableViewSectionComponent(),
                                                                         footerComponent: TestTableViewSectionComponent()))
        
        XCTAssertEqual(section.calculate(height: .height, for: .header), UITableView.automaticDimension)
        XCTAssertEqual(section.calculate(height: .height, for: .footer), UITableView.automaticDimension)
    }
    
    func test_calculateHeight_returnsZeroForNonSetEstimatedSupplementaryViewsHeights() {
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: TestTableViewSectionComponent(),
                                                                       footerComponent: TestTableViewSectionComponent()))
        
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .header), 0)
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .footer), 0)
    }
    
    func test_calculateHeight_returnZeroForHeightOfNonDisplayedSupplementaryViews() {
        let section = TableViewSection()
        
        let headerHeight = section.calculate(height: .height, for: .header)
        let footerHeight = section.calculate(height: .height, for: .footer)
        let headerEstimatedHeight = section.calculate(height: .estimatedHeight, for: .header)
        let footerEstimatedHeight = section.calculate(height: .estimatedHeight, for: .footer)
        
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
        
        header.set(height: .height, 40)
        footer.set(height: .height, 40)
        header.set(height: .estimatedHeight, 40)
        footer.set(height: .estimatedHeight, 40)
        
        header.remove(height: .height)
        footer.remove(height: .height)
        header.remove(height: .estimatedHeight)
        footer.remove(height: .estimatedHeight)
        
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))

        XCTAssertEqual(section.calculate(height: .height, for: .header), UITableView.automaticDimension)
        XCTAssertEqual(section.calculate(height: .height, for: .footer), UITableView.automaticDimension)
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .header), 0)
        XCTAssertEqual(section.calculate(height: .estimatedHeight, for: .footer), 0)
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
        let tableView = UITableView()
        var header = TestTableViewSectionComponent()
        
        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        header.set(command: .configuration) { view, _ in
            view.accessibilityIdentifier = string
        }
        
        let section = TableViewSection(componentDisplayOption: .header(component: header))
        
        let headerView = section.view(componentView: .header, for: tableView, in: 0)
        
        XCTAssertEqual(headerView?.accessibilityIdentifier, string)
        XCTAssert(headerView is UITableViewHeaderFooterView)
    }
    
    func test_footerForTableView_returnsConfiguredFooterForSection() {
        let tableView = UITableView()
        var footer = TestTableViewSectionComponent()

        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        footer.set(command: .configuration) { view, _ in
            view.accessibilityIdentifier = string
        }
        
        let section = TableViewSection(componentDisplayOption: .footer(component: footer))

        let footerView = section.view(componentView: .footer, for: tableView, in: 0)
        
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
        
        header.set(command: .configuration) { view, section in
            headerConfiguration = "Configured!"
        }
        
        header.set(command: .didEndDisplaying) { view, section in
            headerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        header.set(command: .willDisplay) { view, section in
            headerWillDisplay = "WillDisplay!"
        }
        
        footer.set(command: .configuration) { view, section in
            footerConfiguration = "Configured!"
        }
        
        footer.set(command: .didEndDisplaying) { view, section in
            footerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        footer.set(command: .willDisplay) { view, section in
            footerWillDisplay = "WillDisplay!"
        }
        
        let view = UITableViewHeaderFooterView()
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        section.perform(command: .configuration, componentView: .header, for: view, in: 0)
        section.perform(command: .configuration, componentView: .footer, for: view, in: 0)
        section.perform(command: .didEndDisplaying, componentView: .header, for: view, in: 0)
        section.perform(command: .didEndDisplaying, componentView: .footer, for: view, in: 0)
        section.perform(command: .willDisplay, componentView: .header, for: view, in: 0)
        section.perform(command: .willDisplay, componentView: .footer, for: view, in: 0)
        
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
        
        header.set(command: .configuration) { view, section in
            headerConfiguration = "Configured!"
        }
        
        footer.set(command: .configuration) { view, section in
            footerConfiguration = "Configured!"
        }
        
        let view = UIView()
        
        let section = TableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        section.perform(command: .configuration, componentView: .header, for: view, in: 0)
        section.perform(command: .configuration, componentView: .footer, for: view, in: 0)
        
        XCTAssertEqual(headerConfiguration, "")
        XCTAssertEqual(footerConfiguration, "")
    }
    
}
