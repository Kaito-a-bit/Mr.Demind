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
    var notificationType = ["publish", "view", "assign"]
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
    
    func updateRawIndex(item: ToggledDates, index: [Int?]) -> [Int?] {
        var assessedIndex: [Int?] = index
        let pub_toggle = item.pub_Date_IsToggled
        let view_toggle = item.view_Date_IsToggled
        assessedIndex[0] = pub_toggle == false ? nil : index[0]
        assessedIndex[1] = view_toggle == false ? nil : index[1]
        assessedIndex[2] = index[2]
        print(assessedIndex)
        return assessedIndex
    }
    
    //日曜始点のIndexからDateComponentsを作成する
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
    
    
    func createNotification(item: registeredItem) {
        for (_, value) in item.uuidAndDate {
            if let idAndDate = value.first {
                let content = UNMutableNotificationContent()
                //ここcontinueね
                guard let date = idAndDate.value else { continue }
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                content.title = "\(item.classTitle)が公開されました！"
                content.body = "視聴期限は\(DayOfTheWeek.allCases[item.arrForButtons[2]])"
                let request = UNNotificationRequest(identifier: idAndDate.key, content: content, trigger: trigger)
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
 
    func editNotification(item: registeredItem) {
        for (_, value) in item.uuidAndDate {
            if let idAndDate = value.first {
                if idAndDate.value == nil {
                    deleteNotification(uuid: idAndDate.key)
                } else {
                    let content = UNMutableNotificationContent()
                    guard let date = idAndDate.value else { continue }
                    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                    content.title = "\(item.classTitle)が公開されました！"
                    content.body = "視聴期限は\(DayOfTheWeek.allCases[item.arrForButtons[2]])"
                    let request = UNNotificationRequest(identifier: idAndDate.key, content: content, trigger: trigger)
                    notificationCenter.add(request) { (error) in
                        if error != nil {
                            print(error.debugDescription)
                        }
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
    
    func createDictForIdAndDates(id: [String], date: [DateComponents?]) -> [String: [String: DateComponents?]] {
        var dict: [String: [String: DateComponents?]] = [:]
        for i in 0..<(id.count) {
            //わかりやすいように「どの通知か」をIDの前に表示する
            dict.updateValue([id[i]: date[i]], forKey: notificationType[i])
        }
        return dict
    }
    
    func extractUUIDs(dict: [String: [String: DateComponents?]]) -> [String] {
        var uuids: [String] = []
        for type in notificationType {
            guard let value = dict[type]?.keys.first else { return [""] }
            uuids.append(value)
        }
        return uuids
    }
}
