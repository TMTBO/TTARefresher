//
//  UILabel+Refresher.swift
//  Pods
//
//  Created by TobyoTenma on 13/05/2017.
//
//

import UIKit

extension TTARefresherProxy where Base: UILabel {
    
    class func refresherLabel() -> UILabel {
        let label = UILabel()
        label.font = TTARefresherLabelConst.font
        label.textColor = TTARefresherLabelConst.textColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    func refresherWidth() -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        guard let text = base.text else { return 0 }
        let width = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: base.font], context: nil).width
        return width
    }
}
