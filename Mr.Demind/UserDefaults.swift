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
    let decoder = JSONDecoder()
    
    func saveItemsForClassTableview(values: [registeredItem]) {
        guard let data = try? encoder.encode(values) else {
            return
        }
        userDefaults.set(data, forKey: Identifiers.keyForItemsForClassTableView)
    }
    
    func restoreItemsForClassTableView() -> [registeredItem]? {
        guard let data = userDefaults.data(forKey: Identifiers.keyForItemsForClassTableView),
              let restoredItemsForClassTableView = try? decoder.decode([registeredItem].self, from: data) else {
                  return nil
              }
        return restoredItemsForClassTableView
    }
    
    
    
}
