//
//  UIDevice.swift
//  LearningCoreML
//
//  Created by ailu on 2024/7/21.
//

import UIKit

public extension UIDevice {
    static func chipIsA13OrLater() -> Bool {
//        let devicePattern = /(AppleTV|iPad|iPhone|Watch|iPod)(\d+),(\d+)/
//
//        if let match = current.model.firstMatch(of: devicePattern) {
//            let deviceModel = match.1
//            let majorRevision = Int(match.2)!
//
//            return (deviceModel == "iPhone" || deviceModel == "iPad") && majorRevision >= 12
//        }

        return true
    }

    static let modelIsValid: Bool = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func isDeviceValid(identifier: String) -> Bool {
            // swiftlint:disable:this cyclomatic_complexity
            #if os(tvOS)
                switch identifier {
                case "AppleTV5,3": return false
                case "AppleTV6,2": return false
                case "i386", "x86_64": return false
                default: return false
                }
            #elseif os(iOS)
                return true
            #endif
        }

        return isDeviceValid(identifier: identifier)
    }()
}
