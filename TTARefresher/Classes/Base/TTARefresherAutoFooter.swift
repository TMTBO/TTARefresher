//
//  TTARefresherAutoFooter.swift
//  Pods
//
//  Created by TobyoTenma on 11/05/2017.
//
//

import UIKit

open class TTARefresherAutoFooter: TTARefresherFooter {

    public var isAutoRefresh = true
    /// The percent when the footer appear will get refresh, default is 1.0
    public var triggerAutoRefreshPercent: CGFloat = 1.0
    
    open override var state: TTARefresherState {
        didSet {
            if state == oldValue { return }
            if state == .refreshing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                    guard let `self` = self else { return }
                    self.executeRefreshingHandler()
                })
            } else if state == .noMoreData || state == .idle {
                if oldValue == .refreshing {
                    endRefreshingCompletionHandler?()
                }
            }
        }
    }
    
    open override var isHidden: Bool {
        didSet {
            if !oldValue && isHidden {
                state = .idle
                scrollView?.contentInset.bottom -= bounds.height
            } else if oldValue && !isHidden {
                scrollView?.contentInset.bottom += bounds.height
                guard let scrollView = scrollView else { return }
                frame.origin.y = scrollView.contentSize.height
            }
        }
    }
 
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = scrollView else { return }
        if let _ = newSuperview {
            if isHidden == false {
                scrollView.contentInset.bottom += bounds.height
            }
            frame.origin.y = scrollView.contentSize.height
        } else {
            guard isHidden == true else { return }
            scrollView.contentInset.bottom -= bounds.height
        }
    }
}

// MARK: - Override Methods

extension TTARefresherAutoFooter {
    
    override open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        guard let scrollView = scrollView else { return }
        frame.origin.y = scrollView.contentSize.height
    }
    
    override open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView = scrollView else { return }
        if state != .idle || !isAutoRefresh || frame.origin.y == 0 { return }
        guard scrollView.contentInset.top + scrollView.contentSize.height > scrollView.bounds.height else { return }
        let offsetY = scrollView.contentSize.height - scrollView.bounds.height + bounds.height * triggerAutoRefreshPercent + scrollView.contentInset.bottom - bounds.height
        guard scrollView.contentOffset.y >= offsetY else { return }
        if let change = change,
            let old = change[.oldKey] as? CGPoint,
            let new = change[.newKey] as? CGPoint,
            new.y <= old.y { return }
        beginRefreshing()
    }
    
    override open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)
        guard let scrollView = scrollView else { return }
        if state != .idle { return }
        if scrollView.panGestureRecognizer.state == .ended {
            if scrollView.contentInset.top + scrollView.contentSize.height <= scrollView.bounds.height {
                guard scrollView.contentOffset.y >= -scrollView.contentInset.top else { return }
                beginRefreshing()
            } else {
                guard scrollView.contentOffset.y >= scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.height else { return }
                beginRefreshing()
            }
        }
    }

}
