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
    
    var cellText = "TTARefresher"

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
}

extension ViewController {
    
    func prepareTableView() {
        tableView.tableFooterView = UIView()
        prepareHeader()
        prepareFooter()
    }
    
    func prepareHeader() {
        let header = TTARefresherHeader {
            self.loadNew()
        }
        //        let header = TTARefresherHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        header.backgroundColor = .red
        tableView.tta.header = header
    }
    
    func prepareFooter() {
//        let footer = TTARefresherBackStateFooter {
//            self.loadMore()
//        }
        let footer = TTARefresherBackStateFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        footer.backgroundColor = .cyan
        tableView.tta.footer = footer
    }
}

extension ViewController {
    
    func loadNew() {
        print("Hellow Header")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.cellText = "TTARefresher"
            self.tableView.tta.header?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func loadMore() {
        print("Hello Footer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.cellText = "Hello World"
            self.tableView.tta.footer?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellText
        return cell
    }
}

