//
//  TTARefresherGifHeader.swift
//  Pods
//
//  Created by TobyoTenma on 12/05/2017.
//
//

import UIKit

open class TTARefresherGifHeader: TTARefresherStateHeader {

    lazy var gifImageView: UIImageView = {
        let gifImageView = UIImageView()
        self.addSubview(gifImageView)
        return gifImageView
    }()
    
    public lazy var stateImages: [TTARefresherState: [UIImage]] = [:]
    public lazy var stateDurations: [TTARefresherState: TimeInterval] = [:]

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
                guard let images = stateImages[state] else { return }
                if images.count == 0 { return }
                gifImageView.stopAnimating()
                if images.count == 1 { // Single Image
                    gifImageView.image = images.last
                } else { // More than one image
                    gifImageView.animationImages = images
                    gifImageView.animationDuration = stateDurations[state] ?? Double(images.count) * 0.1
                    gifImageView.startAnimating()
                }
            } else if state == .idle {
                gifImageView.stopAnimating()
            }
        }
    }
}

// MARK: - Public Methods

extension TTARefresherGifHeader {

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

extension TTARefresherGifHeader {
    
    override func prepare() {
        super.prepare()
        labelLeftInset = 20
    }

    override func placeSubviews() {
        super.placeSubviews()
        if gifImageView.constraints.count != 0 { return }
        gifImageView.frame = bounds
        if stateLabel.isHidden && lastUpdatedTimeLabel.isHidden {
            gifImageView.contentMode = .center
        } else {
            gifImageView.contentMode = .right
            
            let stateWidth = stateLabel.ttaRefresher.refresherWidth()
            var timeWidth: CGFloat = 0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.ttaRefresher.refresherWidth()
            }
            let textWidth = max(stateWidth, timeWidth)
            gifImageView.frame.size.width = bounds.width * 0.5 - textWidth * 0.5 - labelLeftInset
        }
        
    }
}
