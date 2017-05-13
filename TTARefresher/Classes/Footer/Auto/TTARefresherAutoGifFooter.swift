//
//  TTARefresherAutoGifFooter.swift
//  Pods
//
//  Created by TobyoTenma on 13/05/2017.
//
//

import UIKit

open class TTARefresherAutoGifFooter: TTARefresherAutoStateFooter {

    open lazy var gifImageView: UIImageView = {
        let gifImageView = UIImageView()
        self.addSubview(gifImageView)
        return gifImageView
    }()
    
    lazy var stateImages: [TTARefresherState: [UIImage]] = [:]
    lazy var stateDurations: [TTARefresherState: TimeInterval] = [:]

    open override var state: TTARefresherState {
        didSet {
            if oldValue == state { return }
            if state == .refreshing {
                guard let images = stateImages[state],
                    images.count != 0 else { return }
                gifImageView.stopAnimating()
                
                gifImageView.isHidden = false
                if images.count == 1 { // Sigle image
                    gifImageView.image = images.last
                } else { // More than one images
                    gifImageView.animationImages = images
                    gifImageView.animationDuration = stateDurations[state] ?? Double(images.count) * 0.1
                    gifImageView.startAnimating()
                }
            } else if state == .noMoreData || state == .idle {
                gifImageView.stopAnimating()
                gifImageView.isHidden = true
            }
        }
    }
}

// MARK: - Public Methods

extension TTARefresherAutoGifFooter {
    
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

extension TTARefresherAutoGifFooter {
    
    override func prepare() {
        super.prepare()
        labelLeftInset = 20
    }

    override func placeSubviews() {
        super.placeSubviews()
        if gifImageView.constraints.count != 0 { return }
        gifImageView.frame = bounds
        if isRefreshingTitleHidden {
            gifImageView.contentMode = .center
        } else {
            gifImageView.contentMode = .right
            gifImageView.frame.size.width = bounds.width * 0.5 - labelLeftInset - stateLabel.ttaRefresher.textWidth() * 0.5
        }
    }
}
