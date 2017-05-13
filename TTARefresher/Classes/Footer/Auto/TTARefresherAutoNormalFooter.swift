//
//  TTARefresherAutoNormalFooter.swift
//  Pods
//
//  Created by TobyoTenma on 13/05/2017.
//
//

import UIKit

open class TTARefresherAutoNormalFooter: TTARefresherAutoStateFooter {
    
    public var indicatotStyle = UIActivityIndicatorViewStyle.gray {
        didSet {
            loadingView = nil
            setNeedsLayout()
        }
    }

    lazy var loadingView: UIActivityIndicatorView? = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: self.indicatotStyle)
        self.addSubview(indicator)
        return indicator
    }()

}
