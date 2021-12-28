//
//  AddNotificationViewController.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/11/07.
//

import UIKit

//通知トグル画面
class AddNotificationViewController: UIViewController {
    
    @IBOutlet weak var switchPubDateNotes: UISwitch!
    @IBOutlet weak var switchViewDateNotes: UISwitch!
    static var toggledItem: ToggledDates! = ToggledDates(pub_Date_IsToggled: true,
                                                         view_Date_IsToggled: true)
    var inheritedItem = TaskRegisterViewController.inheritedItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isModalInPresentation = true
        print("called")
        switch TaskRegisterViewController.fromWhere {
        case .register:
            switchPubDateNotes.isOn = true
            switchViewDateNotes.isOn = true
        case .edit:
            switchPubDateNotes.isOn = TaskRegisterViewController.inheritedItem.ToggledDates.pub_Date_IsToggled
            switchViewDateNotes.isOn = TaskRegisterViewController.inheritedItem.ToggledDates.view_Date_IsToggled
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension AddNotificationViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
}
