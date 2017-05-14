//
//  TTARefresherBackStateFooter.swift
//  Pods
//
//  Created by TobyoTenma on 09/05/2017.
//
//

import UIKit

open class TTARefresherBackStateFooter: TTARefresherBackFooter {
    
    public lazy var stateLabel: UILabel = {
        let label = UILabel.TTARefresher.refresherLabel()
        self.addSubview(label)
        return label
    }()
    var stateTitles = [TTARefresherState: String]()
    
    var labelLeftInset = TTARefresherLabelConst.labelLeftInset
    
    open override var state: TTARefresherState {
        didSet {
            if state == oldValue { return }
            stateLabel.text = stateTitles[state]
        }
    }
}

// MARK: - Public Method

extension TTARefresherBackStateFooter {

    public func set(title: String, for state: TTARefresherState) {
        stateTitles[state] = title
        stateLabel.text = stateTitles[self.state]
    }
    
    public func title(for state: TTARefresherState) -> String? {
        return stateTitles[state]
    }
}

// MARK: - Override Methods

extension TTARefresherBackStateFooter {
    
    override func prepare() {
        super.prepare()
        labelLeftInset = TTARefresherLabelConst.labelLeftInset
        set(title: Bundle.TTARefresher.localizedString(for: TTARefresherBackFooterText.idle), for: .idle)
        set(title: Bundle.TTARefresher.localizedString(for: TTARefresherBackFooterText.pulling), for: .pulling)
        set(title: Bundle.TTARefresher.localizedString(for: TTARefresherBackFooterText.refreshing), for: .refreshing)
        set(title: Bundle.TTARefresher.localizedString(for: TTARefresherBackFooterText.noMoreData), for: .noMoreData)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if stateLabel.constraints.count != 0 { return }
        stateLabel.frame = bounds
    }
}
