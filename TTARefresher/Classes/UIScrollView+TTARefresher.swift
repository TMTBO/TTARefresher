//
//  UIScrollView+TTARefresher.swift
//  Pods
//
//  Created by TobyoTenma on 06/05/2017.
//
//

import UIKit

// MARK: - Refresher Header and Footer

extension TTARefresherProxy where Base: UIScrollView {
    
    public var header: TTARefresherComponent? {
        get {
            let header = objc_getAssociatedObject(base, &TTARefresherAssociatedKey.headerKey) as? TTARefresherComponent
            return header
        }
        
        set {
            guard newValue !== header else { return }
            header?.removeFromSuperview()
            guard let newHeader = newValue else { return }
            base.insertSubview(newHeader, at: 0)
            base.willChangeValue(forKey: "TTAHeader")
            objc_setAssociatedObject(base, &TTARefresherAssociatedKey.headerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.didChangeValue(forKey: "TTAHeader")
        }
    }
    
    public var footer: TTARefresherComponent? {
        get {
            let footer = objc_getAssociatedObject(base, &TTARefresherAssociatedKey.footerKey) as? TTARefresherComponent
            return footer
        }
        
        set {
            guard newValue !== footer else { return }
            footer?.removeFromSuperview()
            guard let newFooter = newValue else { return }
            base.insertSubview(newFooter, at: 0)
            base.willChangeValue(forKey: "TTAFooter")
            objc_setAssociatedObject(base, &TTARefresherAssociatedKey.footerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.didChangeValue(forKey: "TTAFooter")
        }
    }
    
}

// MARK: - Other

extension TTARefresherProxy where Base: UIScrollView {
    
    public var totalDataCount: Int {
        var totalCount = 0
        if base.isKind(of: UITableView.self),
            let tableView = base as? UITableView {
            for section in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        } else if base.isKind(of: UICollectionView.self),
            let collectionView = base as? UICollectionView {
            for section in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
    
    var reloadDataHandler: ((Int) -> ())? {
        get{
            return objc_getAssociatedObject(base, &TTARefresherAssociatedKey.reloadDataHandlerKey) as? (Int) -> ()
        }
        set {
            base.willChangeValue(forKey: "reloadDataHandler")
            objc_setAssociatedObject(self, &TTARefresherAssociatedKey.reloadDataHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.didChangeValue(forKey: "reloadDataHandler")
        }
    }
    
    func executeReloadDataHandler() {
        reloadDataHandler?(totalDataCount)
    }
}


fileprivate struct TTARefresherAssociatedKey {
    static var headerKey: Void?
    static var footerKey: Void?
    static var reloadDataHandlerKey: Void?
}

public final class TTARefresherProxy<Base> {
    
    fileprivate let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol TTARefresherCompatiable {}

extension TTARefresherCompatiable {
    
    public var tta: TTARefresherProxy<Self> {
        return TTARefresherProxy(self)
    }
}

extension UIScrollView: TTARefresherCompatiable {}
