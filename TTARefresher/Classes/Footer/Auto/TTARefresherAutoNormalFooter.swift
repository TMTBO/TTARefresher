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
        indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        return indicator
    }()
    
    open override var state: TTARefresherState {
        didSet {
            if oldValue == state { return }
            if state == .noMoreData || state == .idle {
                loadingView?.stopAnimating()
            } else if state == .refreshing {
                loadingView?.startAnimating()
            }
        }
    }
}

// MARK: - Override Methods

extension TTARefresherAutoNormalFooter {
    
    override open func placeSubviews() {
        super.placeSubviews()
        if loadingView?.constraints.count != 0 { return }
        var loadingCenterX = bounds.width * 0.5
        if !stateLabel.isHidden {
            loadingCenterX -= stateLabel.ttaRefresher.textWidth() * 0.5 + labelLeftInset
        }
        let loadingCenterY = bounds.height * 0.5
        loadingView?.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }
 
}
