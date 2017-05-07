//
//  ViewController.swift
//  TTARefresher
//
//  Created by TMTBO on 05/06/2017.
//  Copyright (c) 2017 TMTBO. All rights reserved.
//

import UIKit
import TTARefresher

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    func prepareTableView() {
        tableView.tableFooterView = UIView()
        prepareHeader()
        prepareFooter()
    }
    
    func prepareHeader() {
        let aview = TTARefresherHeader { 
            print("Hello Header")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.tta.header?.endRefreshing()
            })
        }
//        let aview = TTARefresherHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        aview.backgroundColor = .red
        tableView.tta.header = aview
    }
    
    func prepareFooter() {
        let footer = TTARefresherFooter { 
            print("Hello Footer")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.tta.footer?.endRefreshing()
            })
        }
        footer.backgroundColor = .cyan
        tableView.tta.footer = footer
    }
}

extension ViewController {
    
    func loadNew() {
        print("hello world")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.tableView.tta.header?.endRefreshing()
        })
    }
}

