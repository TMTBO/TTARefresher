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
        let header = TTARefresherGifHeader {
            self.loadNew()
        }
//        let header = TTARefresherStateHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
//        header.backgroundColor = .red
//        header.stateLabel.isHidden = true
//        header.lastUpdatedTimeLabel.isHidden = true
        header.labelLeftInset = 10
        let (idleImages, refreshingImages) = prepareAnimationImages()
        header.set(images: idleImages, for: .idle)
        header.set(images: refreshingImages, for: .refreshing)
        tableView.ttaRefresher.header = header
    }
    
    func prepareFooter() {
//        let footer = TTARefresherAutoStateFooter {
//            self.loadMore()
//        }
        let footer = TTARefresherBackGifFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
//        footer.backgroundColor = .cyan
        footer.stateLabel.isHidden = true
        let (idleImages, refreshingImages) = prepareAnimationImages()
        footer.set(images: idleImages, for: .idle)
        footer.set(images: refreshingImages, for: .refreshing)
        tableView.ttaRefresher.footer = footer
    }
}

extension ViewController {
    
    func loadNew() {
        print("Hello Header")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.cellText = "TTARefresher"
            self.tableView.ttaRefresher.header?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func loadMore() {
        print("Hello Footer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.cellText = "Hello World"
            self.tableView.ttaRefresher.footer?.endRefreshing()
//            self.tableView.ttaRefresher.footer?.state = .noMoreData
            self.tableView.reloadData()
        })
    }
    
    func prepareAnimationImages() -> ([UIImage], [UIImage]) {
        var idleImages = [UIImage]()
        for index in 1...60 {
            let imageName = "dropdown_anim__000\(index)"
            guard let image = UIImage(named: imageName) else { continue }
            idleImages.append(image)
        }
        var refreshingImages = [UIImage]()
        for index in 1...3 {
            let imageName = "dropdown_loading_0\(index)"
            guard let image = UIImage(named: imageName) else { continue }
            refreshingImages.append(image)
        }
        return (idleImages, refreshingImages)
    }
    
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellText
        return cell
    }
}

