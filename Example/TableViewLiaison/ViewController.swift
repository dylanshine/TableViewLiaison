//
//  ViewController.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 01/31/2019.
//  Copyright (c) 2019 Shine Labs. All rights reserved.
//

import UIKit
import TableViewLiaison

final class ViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private let liaison = TableViewLiaison()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshSections), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        liaison.paginationDelegate = self
        liaison.liaise(tableView: tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        liaison.append(sections: randomPostSections(), animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func randomPostSections() -> [TableViewSection] {
        return (0...8).map { _ in
            let post = Post()
            return PostTableViewSectionFactory.section(for: post)
        }
    }
    
    @objc private func refreshSections() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NetworkManager.flushCache()
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

