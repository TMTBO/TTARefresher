//
//  TTARefresherConst.swift
//  Pods
//
//  Created by TobyoTenma on 07/05/2017.
//
//

import Foundation

struct TTARefresherLabelConst {
    static let font = UIFont.systemFont(ofSize: 14)
    static let textColor = UIColor(red: 90 / 255, green: 90 / 255, blue: 90 / 255, alpha: 1)
}

struct TTARefresherFrameConst {
    static let headerHeight: CGFloat = 54
    static let footerHeight: CGFloat = 44
}

struct TTARefresherAnimationDuration {
    static let fast = 0.25
    static let slow = 0.4
}

struct TTARefresherObserverKeyPath {
    static let contentOffset = "contentOffset"
    static let contentInset = "contentInset"
    static let contentSize = "contentSize"
    static let panState = "state"
}

struct TTARefresherUserDefaultKey {
    static let lastUpdatedTime = "TTARefresherUserDefaultLastUpdatedTimeKey"
}
