//
//  UIScrollView+TTARefresher.swift
//  Pods
//
//  Created by TobyoTenma on 06/05/2017.
//
//

import UIKit

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
            let footer = objc_getAssociatedObject(self, &TTARefresherAssociatedKey.footerKey) as? TTARefresherComponent
            return footer
        }
        
        set {
            guard newValue !== footer else { return }
            footer?.removeFromSuperview()
            guard let newFooter = newValue else { return }
            base.insertSubview(newFooter, at: 0)
            base.willChangeValue(forKey: "TTAFooter")
            objc_setAssociatedObject(self, &TTARefresherAssociatedKey.footerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            base.didChangeValue(forKey: "TTAFooter")
        }
    }
    
}

fileprivate struct TTARefresherAssociatedKey {
    static var headerKey: Void?
    static var footerKey: Void?
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
