//
//  AddNotificationViewController.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/07.
//

import UIKit

class AddNotificationViewController: UIViewController {
    
    @IBOutlet weak var switchPubDateNotes: UISwitch!
    @IBOutlet weak var switchViewDateNotes: UISwitch!
    static var toggledItem: ToggledDates! = ToggledDates(pub_Date_IsToggled: true,
                                                         view_Date_IsToggled: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch TaskRegisterViewController.fromWhere {
        case .register:
            switchPubDateNotes.isOn = true
            switchViewDateNotes.isOn = true
        case .edit:
            break
        }
    }
    
    //公開日のトグル
    @IBAction func SwitchPubDateNotes(_ sender: Any) {
        AddNotificationViewController.toggledItem.pub_Date_IsToggled.toggle()
    }
    
    //視聴期限のトグル
    @IBAction func SwitchViewDateNotes(_ sender: Any) {
        AddNotificationViewController.toggledItem.view_Date_IsToggled.toggle()
    }
}
