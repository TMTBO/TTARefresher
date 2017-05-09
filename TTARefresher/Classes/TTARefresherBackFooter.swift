//
//  TTARefresherBackFooter.swift
//  Pods
//
//  Created by TobyoTenma on 08/05/2017.
//
//

import UIKit

public class TTARefresherBackFooter: TTARefresherFooter {
    
    var lastRefreshCount = 0
    var lastBottomDelta: CGFloat = 0
    
    override public var state: TTARefresherState {
        didSet {
            if state == oldValue { return }
            guard let scrollView = scrollView else { return }
            if state == .noMoreData || state == .idle {
                if oldValue == .refreshing {
                    UIView.animate(withDuration: TTARefresherAnimationDuration.slow, animations: { [weak self] in
                        guard let `self` = self else { return }
                        scrollView.contentInset.bottom -= self.lastBottomDelta
                        
                        if self.isAutoChangeAlpha { self.alpha = 0 }
                    }, completion: { [weak self] (isFinished) in
                        guard let `self` = self else { return }
                        self.pullingPercent = 0
                        self.endRefreshingCompletionHandler?()
                    })
                    
                }
                let deltaHeihgt = heightForContentBreakView()
                if oldValue == .refreshing && deltaHeihgt > 0 && scrollView.tta.totalDataCount != lastRefreshCount {
                    scrollView.contentOffset.y = scrollView.contentOffset.y
                }
            } else if state == .refreshing {
                lastRefreshCount = scrollView.tta.totalDataCount
                
                UIView.animate(withDuration: TTARefresherAnimationDuration.fast, animations: { [weak self] in
                    guard let `self` = self else { return }
                    var bottom = self.bounds.height + self.scrollViewOriginalInset.bottom
                    let deltaHeight = self.heightForContentBreakView()
                    if deltaHeight < 0 { bottom -= deltaHeight }
                    self.lastBottomDelta = bottom - scrollView.contentInset.bottom
                    scrollView.contentInset.bottom = bottom
                    scrollView.contentOffset.y = self.happenOffsetY() + self.bounds.height
                }, completion: { [weak self] (isFinished) in
                    guard let `self` = self else { return }
                    self.executeRefreshingHandler()
                })
            }
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        scrollViewContentSizeDidChange(nil)
    }
}

// MARK: - Observer Methods

extension TTARefresherBackFooter {
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        if state == .refreshing { return }
        guard let scrollView = scrollView else { return }
        scrollViewOriginalInset = scrollView.contentInset
        
        let currentOffsetY = scrollView.contentOffset.y
        let happenOffsetY = self.happenOffsetY()
        if currentOffsetY <= happenOffsetY { return }
        let pullingPercent = (currentOffsetY - happenOffsetY) / bounds.height
        if state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            let normal2PullingOffsetY = happenOffsetY + bounds.height
            
            if state == .idle && currentOffsetY > normal2PullingOffsetY {
                state = .pulling
            } else if state == .pulling && currentOffsetY <= normal2PullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        guard let scrollView = scrollView else { return }
        let contentHeight = scrollView.contentSize.height + ignoredScrollViewContentInsetBottom
        let scrollHeight = scrollView.bounds.height - scrollViewOriginalInset.top - scrollViewOriginalInset.bottom + ignoredScrollViewContentInsetBottom
        frame.origin.y = max(contentHeight, scrollHeight)
    }
    
}

// MARK: - Override Methods

extension TTARefresherBackFooter {
    
    public override func endRefreshing(_ completionHandler: TTARefresherComponentEndCompletionHandler?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.state = .idle
        }
    }
    
    public override func endRefreshWithNoMoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.state = .noMoreData
        }
    }
}

// MARK: - Private Methods

extension TTARefresherBackFooter {
 
    func heightForContentBreakView() -> CGFloat {
        guard let scrollView = scrollView else { return 0 }
        let height = scrollView.frame.height - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
        return scrollView.contentSize.height - height
    }
 
    func happenOffsetY() -> CGFloat {
        let deltaHeight = heightForContentBreakView()
        if deltaHeight > 0 {
            return deltaHeight - scrollViewOriginalInset.top
        } else {
            return -scrollViewOriginalInset.top
        }
    }
}
