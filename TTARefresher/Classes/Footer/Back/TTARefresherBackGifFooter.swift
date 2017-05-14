//
//  TTARefresherBackGifFooter.swift
//  Pods
//
//  Created by TobyoTenma on 13/05/2017.
//
//

import UIKit

open class TTARefresherBackGifFooter: TTARefresherBackStateFooter {
    
    open lazy var gifImageView: UIImageView = {
        let gifImageView = UIImageView()
        self.addSubview(gifImageView)
        return gifImageView
    }()
    
    lazy var stateImages: [TTARefresherState: [UIImage]] = [:]
    lazy var stateDurations: [TTARefresherState: TimeInterval] = [:]

    override open var pullingPercent: CGFloat {
        didSet {
            guard let images = stateImages[.idle] else { return }
            if state != .idle || images.count == 0 { return }
            gifImageView.stopAnimating()
            var index = CGFloat(images.count) * pullingPercent
            if index >= CGFloat(images.count) {
                index = CGFloat(images.count) - 1
            }
            gifImageView.image = images[Int(index)]
        }
    }

    override open var state: TTARefresherState {
        didSet {
            if oldValue == state { return }
            if state == .pulling || state == .refreshing {
                guard let images = stateImages[state],
                    images.count != 0  else { return }
                gifImageView.isHidden = false
                gifImageView.stopAnimating()
                if images.count == 1 { // Single Image
                    gifImageView.image = images.last
                } else { // More than one image
                    gifImageView.animationImages = images
                    gifImageView.animationDuration = stateDurations[state] ?? Double(images.count) * 0.1
                    gifImageView.startAnimating()
                }
            } else if state == .idle {
                gifImageView.isHidden = false
            } else if state == .noMoreData {
                gifImageView.isHidden = true
            }
        }
    }
}

// MARK: - Public Methods

extension TTARefresherBackGifFooter {
    
    public func set(images: [UIImage]?, duration: TimeInterval?, for state: TTARefresherState) {
        guard let images = images,
            let duration = duration else { return }
        stateImages[state] = images
        stateDurations[state] = duration
        
        guard let image = images.first,
            image.size.height > bounds.height else { return }
        bounds.size.height = image.size.height
    }
    
    public func set(images: [UIImage]?, for state: TTARefresherState) {
        guard let images = images else { return }
        set(images: images, duration: Double(images.count) * 0.1, for: state)
    }
}

// MARK: - Override Methods

extension TTARefresherBackGifFooter {
    
    override open func prepare() {
        super.prepare()
        labelLeftInset = 20
    }

    override open func placeSubviews() {
        super.placeSubviews()
        if gifImageView.constraints.count != 0 { return }
        gifImageView.frame = bounds
        if stateLabel.isHidden {
            gifImageView.contentMode = .center
        } else {
            gifImageView.contentMode = .right
            gifImageView.frame.size.width = bounds.width * 0.5 - stateLabel.ttaRefresher.textWidth() * 0.5 - labelLeftInset
        }
        
    }
}

