//
//  ViewController.swift
//  TableViewLiaison
//
//  Created by [01;31m[Kacct[m[K<blob>=dylanshine on 01/31/2019.
//  Copyright (c) 2019 [01;31m[Kacct[m[K<blob>=dylanshine. All rights reserved.
//

import UIKit
import TableViewLiaison

final class ViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private let liaison = TableViewLiaison()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshSections), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        liaison.paginationDelegate = self
        liaison.liaise(tableView: tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
        liaison.append(sections: randomPostSections(), animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.liaison.append(row: TableViewContentFactory.actionButtonRow(), to: "1")
            self.liaison.append(row: TableViewContentFactory.actionButtonRow(), to: "2")
        }
    }
    
    private func randomPostSections() -> [TableViewSection] {
        return (0...5).map { _ in
            let post = Post()
            return PostTableViewSectionFactory.section(for: post, tableView: tableView)
        }
    }
    
    @objc private func refreshSections() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.liaison.clearSections(replacedBy: self.randomPostSections(), animated: false)
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension ViewController: TableViewLiaisonPaginationDelegate {
    
    func isPaginationEnabled() -> Bool {
        return true
    }
    
    func paginationStarted(indexPath: IndexPath) {
        
        liaison.scroll(to: indexPath)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.liaison.append(sections: self.randomPostSections(), animated: false)
        }
    }
    
    func paginationEnded(indexPath: IndexPath) {
        
    }

}

