//
//  TTARefresher.swift
//  Pods
//
//  Created by TobyoTenma on 09/05/2017.
//
//

import Foundation

public final class TTARefresherProxy<Base> {
    
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol TTARefresherCompatiable {}

extension TTARefresherCompatiable {
    
    public var ttaRefresher: TTARefresherProxy<Self> {
        return TTARefresherProxy(self)
    }
    
    public static var TTARefresher: TTARefresherProxy<Self>.Type {
        return TTARefresherProxy.self
    }
}

extension UIScrollView: TTARefresherCompatiable {}
extension UILabel: TTARefresherCompatiable {}
extension Bundle: TTARefresherCompatiable {}
