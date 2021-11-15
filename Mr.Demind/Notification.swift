//
//  Notification.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/15.
//

import Foundation

class Notification {
    
    let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    //indexをswiftのDateComponentsの日曜始点に変換
    func convertIntoRawIndex(arr: [Int]) -> [Int?] {
        var rawIndex: [Int?] = []
        if arr.count >= 4 {
            print("There's something wrong with the arrForButtons")
        } else {
            for i in arr {
                switch i {
                case 0:
                    rawIndex.append(nil)
                case 1...6:
                    rawIndex.append(i + 1)
                case 7:
                    rawIndex.append(1)
                default:
                    break
                }
            }
        }
        return rawIndex
    }
    
    func appendNotificationDates(arr: [Int?]) -> [Date?] {
        var notificationDates: [Date?] = []
        var components = DateComponents()
        components.year = 2021
        components.weekOfMonth = 1
        components.weekOfMonth = 1
        components.hour = 9
        components.minute = 0
        
        for i in arr {
            if i == nil {
                notificationDates.append(nil)
                components.weekday = i
                if let date = cal.date(from: components) {
                    notificationDates.append(date)
                }
            }
        }
        return notificationDates
    }
    
    
}
