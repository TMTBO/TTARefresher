//
//  TTARefresherBackNormalFooter.swift
//  Pods
//
//  Created by TobyoTenma on 13/05/2017.
//
//

import UIKit

open class TTARefresherBackNormalFooter: TTARefresherBackStateFooter {

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
        indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        return indicator
    }()

    override open var state: TTARefresherState {
        didSet {
            if oldValue == state { return }
            if state == .idle {
                if oldValue == .refreshing {
                    arrowImageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
                    UIView.animate(withDuration: TTARefresherAnimationDuration.slow, animations: { [weak self] in
                        self?.loadingView?.alpha = 0
                    }, completion: { [weak self] (isFinished) in
                        guard let `self` = self else { return }
                        self.loadingView?.alpha = 1
                        self.loadingView?.stopAnimating()
                        self.arrowImageView.isHidden = false
                    })
                } else {
                    arrowImageView.isHidden = false
                    loadingView?.stopAnimating()
                    UIView.animate(withDuration: TTARefresherAnimationDuration.fast, animations: { [weak self] in
                        self?.arrowImageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
                    })
                }
            } else if state == .pulling {
                arrowImageView.isHidden = false
                loadingView?.stopAnimating()
                UIView.animate(withDuration: TTARefresherAnimationDuration.fast, animations: { [weak self] in
                    self?.arrowImageView.transform = .identity
                })
            } else if state == .refreshing {
                arrowImageView.isHidden = true
                loadingView?.startAnimating()
            } else if state == .noMoreData {
                arrowImageView.isHidden = true
                loadingView?.stopAnimating()
            }
        }
    }
}

// MARK: - Override Methods

extension TTARefresherBackNormalFooter {
 
    override open func placeSubviews() {
        super.placeSubviews()
        var arrowCenterX = bounds.width * 0.5
        if !stateLabel.isHidden {
            arrowCenterX -= labelLeftInset + stateLabel.ttaRefresher.textWidth() * 0.5
        }
        let arrowCenterY = bounds.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        if arrowImageView.constraints.count == 0, let image = arrowImageView.image {
            arrowImageView.bounds.size = image.size
            arrowImageView.center = arrowCenter
        }
        
        if loadingView?.constraints.count == 0 {
            loadingView?.center = arrowCenter
        }
        arrowImageView.tintColor = stateLabel.textColor
    }
}
