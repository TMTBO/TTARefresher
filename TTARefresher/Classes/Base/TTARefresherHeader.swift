//
//  TTARefresherHeader.swift
//  Pods
//
//  Created by TobyoTenma on 07/05/2017.
//
//

import UIKit

public class TTARefresherHeader: TTARefresherComponent {
    
    fileprivate var insetTopDelta: CGFloat = 0
    
    var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: TTARefresherUserDefaultKey.lastUpdatedTime) as? Date
    }
    
    override public var state: TTARefresherState {
        didSet {
            if state == oldValue { return }
            
            if state == .idle {
                if oldValue != .refreshing { return }
                UserDefaults.standard.set(Date(), forKey: TTARefresherUserDefaultKey.lastUpdatedTime)
                UserDefaults.standard.synchronize()
                
                UIView.animate(withDuration: TTARefresherAnimationDuration.slow, animations: { [weak self] in
                    guard let `self` = self,
                        let scrollView = self.scrollView else { return }
                    scrollView.contentInset.top += self.insetTopDelta
                    if self.isAutoChangeAlpha { self.alpha = 0}
                }, completion: { [weak self] (isFinished) in
                    guard let `self` = self else { return }
                    self.pullingPercent = 0
                    self.endRefreshingCompletionHandler?()
                })
            } else if state == .refreshing {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: TTARefresherAnimationDuration.fast, animations: { [weak self] in
                        guard let `self` = self else { return }
                        let top = self.scrollViewOriginalInset.top + self.bounds.height
                        self.scrollView?.contentInset.top = top
                        self.scrollView?.setContentOffset(CGPoint(x: 0, y: -top), animated: false)
                    }, completion: { [weak self] (isFinished) in
                        guard let `self` = self else { return }
                        self.executeRefreshingHandler()
                    })
                }
            }
        }
    }

    public init(refreshingHandler: @escaping TTARefresherComponentRefreshingHandler) {
        super.init(frame: .zero)
        self.refreshingHandler = refreshingHandler
    }
    
    public init(refreshingTarget aTarget: AnyObject, refreshingAction anAction: Selector) {
        super.init(frame: .zero)
        setRefreshingTarget(aTarget: aTarget, anAction: anAction)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension TTARefresherHeader {
    
    public override func endRefreshing(_ completionHandler: TTARefresherComponentEndCompletionHandler?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.state = .idle
        }
    }
}

// MARK: - Private Methods

extension TTARefresherHeader {
    
    func recorrectLastUpdatedTime() {} 
}

// MARK: - Override Methods

extension TTARefresherHeader {
    
    override func prepare() {
        super.prepare()
        recorrectLastUpdatedTime()
        bounds.size.height = TTARefresherFrameConst.headerHeight
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        frame.origin.y = -bounds.height
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView = scrollView else { return }
        if state == .refreshing {
            guard window != nil else { return }
            var insetTop = -scrollView.contentOffset.y > scrollViewOriginalInset.top ? -scrollView.contentOffset.y : scrollViewOriginalInset.top
            insetTop = insetTop > bounds.height + scrollViewOriginalInset.top ? bounds.height + scrollViewOriginalInset.top : insetTop
            scrollView.contentInset.top = insetTop
            insetTopDelta = scrollViewOriginalInset.top - insetTop
            return
        }
        scrollViewOriginalInset = scrollView.contentInset
        
        let offsetY = scrollView.contentOffset.y
        let happenOffsetY = -scrollViewOriginalInset.top
        
        if offsetY > happenOffsetY { return }
        
        let normal2PullingOffsetY = happenOffsetY - bounds.height
        let pullingPercent = (happenOffsetY - offsetY) / bounds.height
        
        if scrollView.isDragging { // dragging
            self.pullingPercent = pullingPercent
            if state == .idle && offsetY < normal2PullingOffsetY {
                state = .pulling
            } else if state == .pulling && offsetY >= normal2PullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
