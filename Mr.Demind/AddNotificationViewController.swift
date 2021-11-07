//
//  AddNotificationViewController.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/07.
//

import UIKit

class AddNotificationViewController: UIViewController {

    var toggledItem: ToggledDates = ToggledDates(pub_Date_IsToggled: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SwitchPubDateNotes(_ sender: Any) {
        self.toggledItem.pub_Date_IsToggled.toggle()
    }
}
