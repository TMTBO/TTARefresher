//
//  Bundle+TTARefresher.swift
//  Pods
//
//  Created by TobyoTenma on 09/05/2017.
//
//

import Foundation

extension TTARefresherProxy where Base: Bundle {
    
    class func ttaRefreshBundle() -> Bundle {
        guard let path = Bundle(for: TTARefresherComponent.self).path(forResource: "TTARefresher", ofType: "bundle"),
            let bundle = Bundle(path: path) else {
            fatalError("Can NOT find the Bundle, named: TTARefresher.bundle")
        }
        print(path)
        return bundle
    }

    class func arrowImage() -> UIImage {
        guard let path = ttaRefreshBundle().path(forResource: "arrow@2x", ofType: "png"),
            let arrowImage = UIImage(contentsOfFile: path) else {
                fatalError("Can NOT find the Image: arrow@2x")
        }
        return arrowImage
    }
    
    class func localizedString(for key: String, value: String? = nil) -> String {
        let language: String
        if let preferredLanguage = Locale.preferredLanguages.first {
            if preferredLanguage.hasPrefix("en") {
                language = "en"
            } else if preferredLanguage.hasPrefix("zh") {
                language = "zh"
            } else {
                language = "en"
            }
        } else {
            language = "en"
        }
        guard let path = ttaRefreshBundle().path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path) else {
                fatalError("Can NOT find the \(language).lproj")
        }
        let value = bundle.localizedString(forKey: key , value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
