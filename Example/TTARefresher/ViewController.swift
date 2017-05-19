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
    var cellTitles: [[String]] {
        return [headerTitles, footerTitles, testTitles]
    }
    var headerTitles = [String]()
    var footerTitles = [String]()
    var testTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        prepareTableView()
    }
    @IBAction func ResetData(_ sender: UIBarButtonItem) {
        self.testTitles = ["This is Default Test Data", "This is Default Test Data"]
        self.tableView.ttaRefresher.header?.endRefreshing()
        self.tableView.reloadData()
    }
}

// MARK: - Headers

extension ViewController {
    
    func defaultHeader() -> TTARefresherNormalHeader {
        let header = TTARefresherNormalHeader {
            self.loadNew()
        }
        return header
    }
    
    func hiddenTimeLabelHeader() -> TTARefresherNormalHeader {
        let header = defaultHeader()
        header.isAutoChangeAlpha = true
        header.lastUpdatedTimeLabel.isHidden = true
        return header
    }
    
    func gifHeader() -> TTARefresherGifHeader {
        let header = TTARefresherGifHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        // The margin between label and images
        header.labelLeftInset = 10
        let (idleImages, refreshingImages) = prepareAnimationImages()
        header.set(images: idleImages, for: .idle)
        header.set(images: refreshingImages, for: .refreshing)
        return header
    }
    
    func gifHiddenStateAndTimeLabelHeader() -> TTARefresherGifHeader {
        let header = gifHeader()
        header.stateLabel.isHidden = true
        header.lastUpdatedTimeLabel.isHidden = true
        return header
    }
    
    func customTextHeader() -> TTARefresherNormalHeader {
        let header = defaultHeader()
        header.set(title: "Pull Me Down", for: .idle)
        header.set(title: "Release Me To Refresh", for: .pulling)
        header.set(title: "Come on, I'm getting the data", for: .refreshing)
        return header
    }
}

// MARK: - Footers

extension ViewController {
    
    func defaultAutoFooter() -> TTARefresherAutoNormalFooter {
        let footer = TTARefresherAutoNormalFooter {
            self.loadMore()
        }
        return footer
    }
    
    func loadLastDataAutoFooter() -> TTARefresherAutoNormalFooter {
        let footer  = TTARefresherAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(endLoadMore))
        return footer
    }
    
    func disableAutoRefreshAutoFooter() -> TTARefresherAutoNormalFooter {
        let footer = defaultAutoFooter()
        footer.isAutoRefresh = false
        return footer
    }
    
    func customTextAutoFooter() -> TTARefresherAutoNormalFooter {
        let footer = defaultAutoFooter()
        footer.set(title: "Darg Me Up", for: .idle)
        footer.set(title: "Release Me To Refresh", for: .pulling)
        footer.set(title: "Come on, I just Refreshing", for: .refreshing)
        return footer
    }
    
    func loadOnceAutoFooter() -> TTARefresherAutoNormalFooter {
        let footer = TTARefresherAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadOnce))
        return footer
    }
    
    func gifAutoFooter() -> TTARefresherAutoGifFooter {
        let footer = TTARefresherAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        let (idleImages, refreshingImages) = prepareAnimationImages()
        footer.set(images: idleImages, for: .idle)
        footer.set(images: refreshingImages, for: .refreshing)
        return footer
    }
    
    func hiddenGifStateLabelAutoFooter() -> TTARefresherAutoGifFooter {
        let footer = gifAutoFooter()
        footer.stateLabel.isHidden = true
        return footer
    }
    
    func defaultBackFooter() -> TTARefresherBackNormalFooter {
        let footer = TTARefresherBackNormalFooter {
            self.loadMore()
        }
        return footer
    }
}

extension ViewController {
 
    func prepareTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func prepareData() {
        headerTitles = [
            "Default Header",
            "Hidden Last Updated Time Label Header",
            "Gif Header",
            "Gif Hidden State And Time Label Header",
            "Custom Text Header"
        ]
        footerTitles = [
            "Default Auto Footer",
            "Auto End Load Data",
            "Auto Disable Auto Refresh",
            "Auto Custom Text",
            "Auto Load Once",
            "Auto Gif Footer",
            "Auto Gif Hidden State Label Footer",
            "Default Back Footer"
        ]
        testTitles = ["This is Default Test Data", "This is Default Test Data"]
    }
}

extension ViewController {
    
    func loadNew() {
        print("Hello Header")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let `self` = self else { return }
            self.testTitles = ["This is Default Test Data", "This is Default Test Data"]
            self.tableView.ttaRefresher.header?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func loadMore() {
        print("Hello Footer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let `self` = self else { return }
            for _ in 0..<5 {
                self.testTitles.append("Random Test Data \(arc4random_uniform(10000))")
            }
            self.tableView.ttaRefresher.footer?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func endLoadMore() {
        print("Hello Footer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let `self` = self else { return }
            for _ in 0..<5 {
                self.testTitles.append("Random Test Data \(arc4random_uniform(10000))")
            }
            self.tableView.ttaRefresher.footer?.endRefreshing()
            self.tableView.ttaRefresher.footer?.endRefreshWithNoMoreData()
            // or
            //  self.tableView.ttaRefresher.footer?.state = .noMoreData
            self.tableView.reloadData()
        })
    }
    
    func loadOnce() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let `self` = self else { return }
            for _ in 0..<5 {
                self.testTitles.append("Random Test Data \(arc4random_uniform(10000))")
            }
            self.tableView.ttaRefresher.footer?.isHidden = true
            self.tableView.ttaRefresher.footer?.endRefreshing()
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
        return cellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellTitles[indexPath.section][indexPath.row]
        if cell.selectedBackgroundView?.backgroundColor != .orange {
            let aview = UIView()
            aview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            aview.backgroundColor = .orange
            cell.selectedBackgroundView = aview
        }
        if indexPath.section == 2 {
            cell.selectionStyle = .none
        } else {
            cell.selectionStyle = .default
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 2 { return nil }
        return indexPath
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let header: TTARefresherHeader
            switch indexPath.row {
            case 0:
                header = defaultHeader()
            case 1:
                header = hiddenTimeLabelHeader()
            case 2:
                header = gifHeader()
            case 3:
                header = gifHiddenStateAndTimeLabelHeader()
            case 4:
                header = customTextHeader()
            default:
                return
            }
            tableView.ttaRefresher.header = header
        } else if indexPath.section == 1 {
            let footer: TTARefresherFooter
            switch indexPath.row {
            case 0:
                footer = defaultAutoFooter()
            case 1:
                footer = loadLastDataAutoFooter()
            case 2:
                footer = disableAutoRefreshAutoFooter()
            case 3:
                footer = customTextAutoFooter()
            case 4:
                footer = loadOnceAutoFooter()
            case 5:
                footer = gifAutoFooter()
            case 6:
                footer = hiddenGifStateLabelAutoFooter()
            case 7:
                footer = defaultBackFooter()
            default:
                return
            }
            tableView.ttaRefresher.footer = footer
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Header Types"
        case 1:
            return "Footer Types"
        case 2:
            return "Test Load Data"
        default:
            return ""
        }
    }
}

