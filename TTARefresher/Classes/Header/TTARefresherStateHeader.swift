//
//  TTARefresherStateHeader.swift
//  Pods
//
//  Created by TobyoTenma on 12/05/2017.
//
//

import UIKit

public class TTARefresherStateHeader: TTARefresherHeader {

    lazy var stateLabel: UILabel = {
        let label = UILabel.ttaRefresherLabel()
        self.addSubview(label)
        return label
    }()
    var stateTitles = [TTARefresherState: String]()
    
    lazy var lastUpdatedTimeLabel: UILabel = {
        let label = UILabel.ttaRefresherLabel()
        self.addSubview(label)
        return label
    }()

}
