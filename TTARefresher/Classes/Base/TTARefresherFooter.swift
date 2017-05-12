//
//  TTARefresherFooter.swift
//  Pods
//
//  Created by TobyoTenma on 07/05/2017.
//
//

import UIKit

public class TTARefresherFooter: TTARefresherComponent {
    
    /// If true, the footer will be shown when there are data, otherwise, footer will be hidden
    var isAutoHidden = false
    
    var ignoredScrollViewContentInsetBottom: CGFloat = 0
    
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

// MARK: - Override Methods

extension TTARefresherFooter {
    
    override func prepare() {
        super.prepare()
        bounds.size.height = TTARefresherFrameConst.footerHeight
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil,
            let scrollView = scrollView else { return }
        if scrollView.isKind(of: UITableView.self) || scrollView.isKind(of: UICollectionView.self) {
            scrollView.tta.reloadDataHandler = { [weak self] (totalDataCount) in
                guard let `self` = self,
                    self.isAutoHidden else { return }
                self.isHidden = totalDataCount == 0
            }
        }
    }
}

// MARK: - Public Methods

extension TTARefresherFooter {
    
    public func endRefreshWithNoMoreData() {
        state = .noMoreData
    }
    
    public func resetNoMoreData() {
        state = .idle
    }
}