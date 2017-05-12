//
//  TTARefresherStateHeader.swift
//  Pods
//
//  Created by TobyoTenma on 12/05/2017.
//
//

import UIKit

open class TTARefresherStateHeader: TTARefresherHeader {

    public lazy var stateLabel: UILabel = {
        let label = UILabel.ttaRefresherLabel()
        self.addSubview(label)
        return label
    }()
    var stateTitles = [TTARefresherState: String]()
    
    /// The margin between Label and left images
    public var labelLeftInset = TTARefresherLabelConst.labelLeftInset
    
    public lazy var lastUpdatedTimeLabel: UILabel = {
        let label = UILabel.ttaRefresherLabel()
        self.addSubview(label)
        return label
    }()
    
    var lastUpdatedTimeTextHandler: ((Date) -> String)?

    open override var state: TTARefresherState {
        didSet {
            if state == oldValue { return }
            stateLabel.text = stateTitles[state]
            recorrectLastUpdatedTime()
        }
    }
}

// MARK: - Public Method

extension TTARefresherStateHeader {

    public func set(title: String, for state: TTARefresherState) {
        stateTitles[state] = title
        stateLabel.text = stateTitles[self.state]
    }
}

// MARK: - Private Methods

extension TTARefresherStateHeader {
    
    func currentCalendar() -> Calendar {
        return Calendar(identifier: .gregorian)
    }
}

// MARK: - Override Methods

extension TTARefresherStateHeader {

    override func recorrectLastUpdatedTime() {
        super.recorrectLastUpdatedTime()
        if lastUpdatedTimeLabel.isHidden { return }
        
        // If `lastUpdatedTimeTextHandler` not nil, update the text with this Cloure
        if let lastUpdatedTimeTextHandler = lastUpdatedTimeTextHandler {
            lastUpdatedTimeLabel.text = lastUpdatedTimeTextHandler(lastUpdatedTime ?? Date())
            return
        }
        
        if let lastUpdatedTime = lastUpdatedTime {
            // Get date
            let calendar = currentCalendar()
            let unitFlags: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
            let cmp1 = calendar.dateComponents(unitFlags, from: lastUpdatedTime)
            let cmp2 = calendar.dateComponents(unitFlags, from: Date())
            
            // Format Date
            let formatter = DateFormatter()
            var isToday = false
            if cmp1.day == cmp2.day { // Today
                formatter.dateFormat = " HH:mm"
                isToday = true
            } else if cmp1.year == cmp2.year { // This Year
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let time = formatter.string(from: lastUpdatedTime)
            
            // Show Date
            let lastTime = Bundle.ttaClass.localizedString(for: TTARefresherHeaderDateText.lastTime)
            let todayTime = isToday ? Bundle.ttaClass.localizedString(for: TTARefresherHeaderDateText.dateToday) : ""
            lastUpdatedTimeLabel.text = lastTime + todayTime + time
        } else {
            lastUpdatedTimeLabel.text = Bundle.ttaClass.localizedString(for: TTARefresherHeaderDateText.lastTime) + Bundle.ttaClass.localizedString(for: TTARefresherHeaderDateText.noneLastDate)
        }
    }
    
    override func prepare() {
        super.prepare()
        set(title: Bundle.ttaClass.localizedString(for: TTARefresherHeaderText.idle), for: .idle)
        set(title: Bundle.ttaClass.localizedString(for: TTARefresherHeaderText.pulling), for: .pulling)
        set(title: Bundle.ttaClass.localizedString(for: TTARefresherHeaderText.refreshing), for: .refreshing)
    }

    override func placeSubviews() {
        super.placeSubviews()
        if stateLabel.isHidden { return }
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0
        if lastUpdatedTimeLabel.isHidden {
            if noConstrainsOnStatusLabel { stateLabel.frame = bounds }
        } else {
            let stateLabelHeight = bounds.height * 0.5
            if noConstrainsOnStatusLabel {
                stateLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: stateLabelHeight)
            }
            if lastUpdatedTimeLabel.constraints.count == 0 {
                lastUpdatedTimeLabel.frame = CGRect(x: 0, y: stateLabelHeight, width: bounds.width, height: bounds.height - lastUpdatedTimeLabel.frame.origin.y)
            }
        }
    }
}
