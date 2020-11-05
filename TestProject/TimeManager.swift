//
//  TimeManager.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit

class TimeManager: NSObject {
    class func getCurrentTime()->String{
        let timeNow = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let strNowTime = timeFormatter.string(from: timeNow) as String
        return strNowTime
    }
}
