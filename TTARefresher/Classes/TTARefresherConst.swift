//
//  TTARefresherConst.swift
//  Pods
//
//  Created by TobyoTenma on 07/05/2017.
//
//

import Foundation

struct TTARefresherLabelConst {
    static let labelLeftInset = 25.0
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

struct TTARefresherHeaderDateText {
    static let lastTime = "TTARefresherHeaderDateLastTimeText"
    static let dateToday = "TTARefresherHeaderDateTodayText"
    static let noneLastDate = "TTARefresherHeaderNoneLastDateText"
}

struct TTARefresherHeaderText {
    static let idle = "TTARefresherHeaderTextIdle"
    static let pulling = "TTARefresherHeaderTextPulling"
    static let refreshing = "TTARefresherHeaderTextRefreshing"
}

struct TTARefresherAutoFooterText {
    static let idle = "TTARefresherAutoFooterTextIdle"
    static let refreshing = "TTARefresherAutoFooterTextRefreshing"
    static let noMoreData = "TTARefresherAutoFooterTextNoMoreData"
}

struct TTARefresherBackFooterText {
    static let idle = "TTARefresherBackFooterTextIdle"
    static let pulling = "TTARefresherBackFooterTextPulling"
    static let refreshing = "TTARefresherBackFooterTextRefreshing"
    static let noMoreData = "TTARefresherBackFooterTextNoMoreData"
}
