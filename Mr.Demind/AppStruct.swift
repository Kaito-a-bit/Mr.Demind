//
//  AppStruct.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/30.
//

import Foundation

// enumeration of the day of the week
enum DayOfTheWeek {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
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
