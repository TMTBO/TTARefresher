//
//  TTARefreshComponent.swift
//  Pods
//
//  Created by TobyoTenma on 07/05/2017.
//
//

import UIKit

/// Refresher States
public enum TTARefresherState: Int {
    case idle = 1, pulling, refreshing, willRefresh, noMoreData
}

public typealias TTARefresherComponentRefreshingHandler = () -> ()
public typealias TTARefresherComponentBeginCompletionHandler = () -> ()
public typealias TTARefresherComponentEndCompletionHandler = () -> ()

/// The Refresher Base Component
open class TTARefresherComponent: UIView {
    
    open var state: TTARefresherState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }
    
    public var refreshingTarget: AnyObject?
    public var refreshingAction: Selector?
    
    public var refreshingHandler: TTARefresherComponentRefreshingHandler?
    public var beginRefreshingCompletionHandler: TTARefresherComponentBeginCompletionHandler?
    public var endRefreshingCompletionHandler: TTARefresherComponentEndCompletionHandler?
    
    public var isRefreshing: Bool {
        return state == .refreshing || state == .willRefresh
    }
    
    open var pullingPercent: CGFloat = 0 {
        didSet {
            if isRefreshing { return }
            if isAutoChangeAlpha {
                alpha = pullingPercent
            }
        }
    }
    
    public var isAutoChangeAlpha = false {
        didSet {
            if isRefreshing { return }
            if isAutoChangeAlpha {
                alpha = pullingPercent
            } else {
                alpha = 1
            }
        }
    }
    
    /// The superView, Readonly for subviews
    public fileprivate(set) var scrollView: UIScrollView?
    /// The ScrollView Original inset, Readonly for subviews
    public internal(set) var scrollViewOriginalInset = UIEdgeInsets.zero
    
    /// ScorllView's pan gesture
    fileprivate var pan: UIPanGestureRecognizer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
        setState()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState() {
        state = .idle
    }
    
    deinit {
        removeObservers()
    }
}

// MARK: - Life Cycle

extension TTARefresherComponent {
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard state == .willRefresh else { return }
        state = .refreshing
    }
    
    override open func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let isScrollView = newSuperview?.isKind(of: UIScrollView.self),
                newSuperview != nil && isScrollView == true else { return }
        removeObservers()
        guard let newSuperview = newSuperview else { return }
        bounds.size.width = newSuperview.bounds.width
        frame.origin.x = 0
        scrollView = newSuperview as? UIScrollView
        guard let scrollView = scrollView else { return }
        scrollView.alwaysBounceVertical = true
        scrollViewOriginalInset = scrollView.contentInset
        addObservers()
    }
}

// MARK: - SubClass rewrite these motheds

extension TTARefresherComponent {
    
    open func prepare() {
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear
    }
    
    open func placeSubviews() {}
    
    open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
    open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
    open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
}

// MARK: - Public Methods

extension TTARefresherComponent {
    
    public func setRefreshingTarget(aTarget: AnyObject, anAction: Selector) {
        refreshingTarget = aTarget
        refreshingAction = anAction
    }
    
    public func beginRefreshing(_ completionHandler: TTARefresherComponentBeginCompletionHandler? = nil) {
        beginRefreshingCompletionHandler = completionHandler
        UIView.animate(withDuration: TTARefresherAnimationDuration.fast) { [weak self] in
            self?.alpha = 1.0
        }
        pullingPercent = 1.0
        if window != nil {
            state = .refreshing
        } else {
            guard state != .refreshing else { return }
            state = .willRefresh
            setNeedsDisplay()
        }
    }
    
    public func endRefreshing(_ completionHandler: TTARefresherComponentEndCompletionHandler? = nil) {
        endRefreshingCompletionHandler = completionHandler
        state = .idle
        
        scrollView?.ttaRefresher.executeReloadDataHandler()
    }
}

// MARK: - Private Methods

extension TTARefresherComponent {
    
    func executeRefreshingHandler() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.refreshingHandler?()
            if let target = self.refreshingTarget,
                let action = self.refreshingAction {
                _ = target.perform(action)
            }
            self.beginRefreshingCompletionHandler?()
        }
    }
    
}

// MARK: - Observers

extension TTARefresherComponent {
    
    func addObservers() {
        guard let scrollView = scrollView else { return }
        let options: NSKeyValueObservingOptions = [.new, .old]
        scrollView.addObserver(self, forKeyPath: TTARefresherObserverKeyPath.contentOffset, options: options, context: nil)
        scrollView.addObserver(self, forKeyPath: TTARefresherObserverKeyPath.contentSize, options: options, context: nil)
        pan = scrollView.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: TTARefresherObserverKeyPath.panState, options: options, context: nil)
    }
    
    func removeObservers() {
        guard let scrollView = scrollView else { return }
        scrollView.removeObserver(self, forKeyPath: TTARefresherObserverKeyPath.contentOffset)
        scrollView.removeObserver(self, forKeyPath: TTARefresherObserverKeyPath.contentSize)
        pan?.removeObserver(self, forKeyPath: TTARefresherObserverKeyPath.panState)
        pan = nil
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard isUserInteractionEnabled else { return }
        if keyPath == TTARefresherObserverKeyPath.contentSize {
            scrollViewContentSizeDidChange(change)
        }
        if isHidden { return }
        if keyPath == TTARefresherObserverKeyPath.contentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == TTARefresherObserverKeyPath.panState {
            scrollViewPanStateDidChange(change)
        }
    }
}
