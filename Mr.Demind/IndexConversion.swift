//
//  IndexConversion.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/10.
//

import Foundation

//指定したインデックスの配列から通知するべき曜日を取得したい
// ex: [0,1,4] → ["-", "火", "木"]
class IndexConversion {
    
    let formatter = DateFormatter()
    let cases = DayOfTheWeek.allCases
    var convertedIndex: [String]!
    
    func IndexConversion(index: [Int]) {
        if index.count >= 4 {
            print("error")
        } else {
            for i in index {
                let newIndex = cases[i]
                convertedIndex.append(newIndex.rawValue)
            }
        }
        
    }
    
    
    
}
