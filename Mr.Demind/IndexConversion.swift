//
//  IndexConversion.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/10.
//

import Foundation

//指定したインデックスの配列から通知関数を作る
// ex: [0,1,4] → ["-", "火", "木"]
class IndexConversion {
    
    let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    var components = DateComponents()
    
    //Indexを取得→日曜基準のNSDateComponentsに変換
    func convertIndex(index: [Int]) -> [Int?] {
        var convertedIndex: [Int?] = []
        if index.count >= 4 {
            print("There's something wrong with the Date Index Arr.")
        } else {
            for i in index {
                switch i {
                case 0:
                    convertedIndex.append(nil)
                case 1...6:
                    convertedIndex.append(i + 1)
                case 7:
                    convertedIndex.append(1)
                default:
                    break
                }
            }
        }
        return convertedIndex
    }
    
    func setUpDateToNote(index: [Int?]) -> [Date?] {
        var datesToNote:[Date?] = []
        cal.locale = NSLocale.current
        components.year = 2021
        components.weekOfMonth = 1
        components.weekOfMonth = 1
        components.hour = 9
        components.minute = 0
        for i in index {
            if i == nil {
                datesToNote.append(nil)
            } else {
                components.weekday = i
                if let date = cal.date(from: components) {
                    datesToNote.append(date)
                }
            }
        }
        return datesToNote
    }
}
