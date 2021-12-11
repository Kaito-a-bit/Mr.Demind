//
//  Notification.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/15.
//

import Foundation
import UserNotifications

struct NotificationProcessing {
    
    let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    let notificationCenter = UNUserNotificationCenter.current()
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
    
    func appendNotificationDates(arr: [Int?]) -> [DateComponents?] {
        var notificationDates: [DateComponents?] = []
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        
        for i in arr {
            if i == nil {
                notificationDates.append(nil)
            } else {
                components.weekday = i
                notificationDates.append(components)
            }
        }
        return notificationDates
    }
    
    func addNotification(item: registeredItems) {
        for i in 0..<(item.NotificationDates.count) {
            if let dateComponent = item.NotificationDates[i] {
                let content = UNMutableNotificationContent()
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                content.title = "\(item.classTitle)が公開されました！"
                content.body = "視聴期限は\(DayOfTheWeek.allCases[item.arrForButtons[2]])"
                let request = UNNotificationRequest(identifier: item.uuidForNote[i], content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
    
    //この関数を使用する場合は引数に指定するUUIDを先に指定しておく
    func deleteNotification(uuid: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
    }
    
    func ammendNotification(item: registeredItems) {
        for i in 0..<(item.NotificationDates.count) {
            if let dateComponent = item.NotificationDates[i] {
                let content = UNMutableNotificationContent()
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                content.title = "\(item.classTitle)が公開されました！"
                content.body = "視聴期限は\(DayOfTheWeek.allCases[item.arrForButtons[2]])"
                let request = UNNotificationRequest(identifier: item.uuidForNote[i], content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
    
    func createUUIDs() -> [String] {
        var idArr: [String] = []
        for _ in 0...2 {
            let id = UUID().uuidString
            idArr.append(id)
        }
        return idArr
    }
    
}
