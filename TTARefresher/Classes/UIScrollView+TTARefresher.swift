//
//  UIScrollView+TTARefresher.swift
//  Pods
//
//  Created by TobyoTenma on 06/05/2017.
//
//

import UIKit

extension TTARefresherProxy where Base: UIScrollView {
    
    var header: UIView? {
        get {
            let header = objc_getAssociatedObject(self, &TTARefresherAssociatedKey.headerKey) as? UIView
            return header
        }
        
        set {
            objc_setAssociatedObject(self, &TTARefresherAssociatedKey.headerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

fileprivate struct TTARefresherAssociatedKey {
    static var headerKey: NSString = "TTAHeaderKey"
}

public final class TTARefresherProxy<Base> {
    
    public let base: Base
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
