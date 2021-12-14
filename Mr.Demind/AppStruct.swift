//
//  AppStruct.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/30.
//

import Foundation

// enumeration of the day of the week
enum DayOfTheWeek: String, CaseIterable, Codable {
    case None = "-" //0
    case Monday = "月"
    case Tuesday = "火"
    case Wednesday = "水"
    case Thursday = "木"
    case Friday = "金"
    case Saturday = "土"
    case Sunday = "日"
}

enum ViewsLeftBehind {
    case register
    case edit
}

// struct for task registration.
struct registeredItem: Codable {
    var classTitle: String
    var arrForButtons: [Int]
    var description: String?
    var ToggledDates: ToggledDates
    var uuidAndDate: [String: [String: DateComponents?]]
}

struct ToggledDates: Codable {
    var pub_Date_IsToggled: Bool
    var view_Date_IsToggled: Bool
}

