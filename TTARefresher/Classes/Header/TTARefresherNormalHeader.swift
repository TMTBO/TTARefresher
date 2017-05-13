//
//  TTARefresherNormalHeader.swift
//  Pods
//
//  Created by TobyoTenma on 12/05/2017.
//
//

import UIKit

open class TTARefresherNormalHeader: TTARefresherStateHeader {
    
    public var indicatotStyle = UIActivityIndicatorViewStyle.gray {
        didSet {
            loadingView = nil
            setNeedsLayout()
        }
    }

    public lazy var arrowImageView: UIImageView = {
        let arrowImage = Bundle.TTARefresher.arrowImage()
        let arrowImageView = UIImageView(image: arrowImage)
        self.addSubview(arrowImageView)
        return arrowImageView
    }()
    
    lazy var loadingView: UIActivityIndicatorView? = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: self.indicatotStyle)
        self.addSubview(indicator)
        return indicator
    }()
    
    open override var state: TTARefresherState {
        didSet {
            if oldValue == state { return }
            if state == .idle {
                if oldValue == .refreshing {
                    arrowImageView.transform = .identity
                    UIView.animate(withDuration: TTARefresherAnimationDuration.slow, animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.loadingView?.alpha = 0
                    }, completion: { [weak self] (isFinished) in
                        guard let `self` = self else { return }
                        if self.state != .idle { return }
                        self.loadingView?.alpha = 1
                        self.loadingView?.stopAnimating()
                        self.arrowImageView.isHidden = false
                    })
                } else {
                    loadingView?.stopAnimating()
                    arrowImageView.isHidden = false
                    UIView.animate(withDuration: TTARefresherAnimationDuration.fast, animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.arrowImageView.transform = .identity
                    })
                }
            } else if state == .pulling {
                loadingView?.stopAnimating()
                arrowImageView.isHidden = false
                UIView.animate(withDuration: TTARefresherAnimationDuration.fast, animations: { [weak self] in
                    guard let `self` = self else { return }
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
                })
            } else if state == .refreshing {
                loadingView?.alpha = 1
                loadingView?.startAnimating()
                arrowImageView.isHidden = true
            }
        }
    }
}

// MARK: - Override Methods

extension TTARefresherNormalHeader {

    override func placeSubviews() {
        super.placeSubviews()
        var arrowCenterX = bounds.width * 0.5
        if !stateLabel.isHidden {
            let stateWidth = stateLabel.ttaRefresher.refresherWidth()
            var timeWidth: CGFloat = 0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.ttaRefresher.refresherWidth()
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth / 2 + labelLeftInset
        }
        let arrowCenterY = bounds.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if arrowImageView.constraints.count == 0 {
            arrowImageView.bounds.size = arrowImageView.image!.size
            arrowImageView.center = arrowCenter
        }
        if loadingView?.constraints.count == 0 {
            loadingView?.center = arrowCenter
        }
        arrowImageView.tintColor = stateLabel.textColor
    }
}
