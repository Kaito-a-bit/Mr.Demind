//
//  AppStruct.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/30.
//

import Foundation

// enumeration of the day of the week
enum DayOfTheWeek: String, CaseIterable {
    case None = "-"
    case Monday = "月"
    case Tuesday = "火"
    case Wednesday = "水"
    case Thursday = "木"
    case Friday = "金"
    case Saturday = "土"
    case Sunday = "日"
}

// struct for task registration.
struct  registeredItems {
    var classTitle: String
    var published_Date: DayOfTheWeek
    var viewing_Deadline: DayOfTheWeek
    var assignment_Deadline: DayOfTheWeek
//    var notification
    var description: String
}
