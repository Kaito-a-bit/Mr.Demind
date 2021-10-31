//
//  UserDefaults.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/31.
//

import Foundation


class UserDataBase {
    
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    func saveItemsForClassTableview(values: [registeredItems]) {
        guard let data = try? encoder.encode(values) else {
            return
        }
        userDefaults.set(data, forKey: Identifiers.keyForItemsForClassTableView)
    }
    
    
    
    
    
}
