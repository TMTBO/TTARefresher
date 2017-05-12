//
//  TTARefresherAutoStateFooter.swift
//  Pods
//
//  Created by TobyoTenma on 11/05/2017.
//
//

import UIKit

public class TTARefresherAutoStateFooter: TTARefresherAutoFooter {

    lazy var stateLabel: UILabel = {
        let label = UILabel.ttaRefresherLabel()
        self.addSubview(label)
        return label
    }()
    var stateTitles = [TTARefresherState: String]()
    var labelLeftInset = 0.0
    var isRefreshingTitleHidden = false
    
    public override var state: TTARefresherState {
        didSet {
            if state == oldValue { return }
            if isRefreshingTitleHidden && state == .refreshing {
                stateLabel.text = nil
            } else {
                stateLabel.text = stateTitles[state]
            }
        }
    }
}

// MARK: - Public Method

extension TTARefresherAutoStateFooter {
    
    public func set(title: String, for state: TTARefresherState) {
        stateTitles[state] = title
        stateLabel.text = stateTitles[self.state]
    }
}

// MARK: - Private Methods

extension TTARefresherAutoStateFooter {
    func didClickStateLabel() {
        guard state == .idle else { return }
        beginRefreshing()
    }
}

// MARK: - Override Methods

extension TTARefresherAutoStateFooter {

    override func prepare() {
        super.prepare()
        labelLeftInset = TTARefresherLabelConst.labelLeftInset
        set(title: Bundle.ttaClass.localizedString(for: TTARefresherAutoFooterText.idle), for: .idle)
        set(title: Bundle.ttaClass.localizedString(for: TTARefresherAutoFooterText.refreshing), for: .refreshing)
        set(title: Bundle.ttaClass.localizedString(for: TTARefresherAutoFooterText.noMoreData), for: .noMoreData)
        stateLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClickStateLabel))
        stateLabel.addGestureRecognizer(tap)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if stateLabel.constraints.count != 0 { return }
        stateLabel.frame = bounds
    }
}
