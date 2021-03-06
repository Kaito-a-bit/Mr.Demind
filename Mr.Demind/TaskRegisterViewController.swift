//
//  TaskRegisterViewController.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/29.
//

import UIKit

class TaskRegisterViewController: UIViewController {
    
    @IBOutlet weak var classTitleTextField: UITextField!
    @IBOutlet weak var publishedDateButton: UIButton!
    @IBOutlet weak var viewingDeadlineButton: UIButton!
    @IBOutlet weak var assignmentDeadlineButton: UIButton!
    @IBOutlet weak var notificationAdditionButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let AddNotificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Identifiers.idForAddNoteVC) as! AddNotificationViewController
    var indexForButtons: [Int] = [0, 0, 0] //「-」を指定
    static var fromWhere: ViewsLeftBehind = .register
    static var inheritedItem: registeredItem!
    
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont.systemFont(ofSize: 12, weight: .medium)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTitleTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch TaskRegisterViewController.fromWhere {
        case .register:
            initRegistrationField()
        case .edit:
            if let values = TaskRegisterViewController.inheritedItem {
                classTitleTextField.text = values.classTitle
                indexForButtons = values.arrForButtons
                publishedDateButton.setAttributedTitle(NSAttributedString(string: "公開日:\(DayOfTheWeek.allCases[values.arrForButtons[0]].rawValue)", attributes: attributes), for: .normal)
                viewingDeadlineButton.setAttributedTitle(NSAttributedString(string: "視聴期限:\(DayOfTheWeek.allCases[values.arrForButtons[1]].rawValue)", attributes: attributes), for: .normal)
                assignmentDeadlineButton.setAttributedTitle(NSAttributedString(string: "課題期限:\(DayOfTheWeek.allCases[values.arrForButtons[2]].rawValue)", attributes: attributes), for: .normal)
                descriptionTextView.text = values.description
            }
        }
    }
    
    @IBAction func addNoteButton(_ sender: Any) {
        AddNotificationVC.modalPresentationStyle = .pageSheet
        if let sheet = AddNotificationVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(AddNotificationVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let isTitileEmpty = classTitleTextField.text == "" ? true : false
        switch isTitileEmpty {
        case true:
            let alert: UIAlertController = UIAlertController(title: "科目名が入力されていません", message: "", preferredStyle:  UIAlertController.Style.actionSheet)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        case false:
            switch TaskRegisterViewController.fromWhere {
                //科目を追加する場合 .register
            case .register:
                
                taskAddition()
                self.dismiss(animated: true, completion: nil)
                //科目を編集する場合 .edit
            case .edit:
                //ここでClassListViewControllerから取ってきた情報を元の場所に戻したい。
                taskEditing()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func publishedDateButton(_ sender: Any) {
        indexForButtons[0] += 1
        indexForButtons[0] = indexForButtons[0] == 8 ? 0 : indexForButtons[0]
        publishedDateButton.setAttributedTitle(NSAttributedString(string: "公開日:\(DayOfTheWeek.allCases[indexForButtons[0]].rawValue)", attributes: attributes), for: .normal)
    }
    
    
    @IBAction func viewingDeadlineButton(_ sender: Any) {
        indexForButtons[1] += 1
        indexForButtons[1] = indexForButtons[1] == 8 ? 0 : indexForButtons[1]
        viewingDeadlineButton.setAttributedTitle(NSAttributedString(string: "視聴期限:\(DayOfTheWeek.allCases[indexForButtons[1]].rawValue)", attributes: attributes), for: .normal)
    }
    
    @IBAction func assignmentDeadlineButton(_ sender: Any) {
        indexForButtons[2] += 1
        indexForButtons[2] = indexForButtons[2] == 8 ? 0 :  indexForButtons[2]
        assignmentDeadlineButton.setAttributedTitle(NSAttributedString(string: "課題期限:\(DayOfTheWeek.allCases[indexForButtons[2]].rawValue)", attributes: attributes), for: .normal)
    }
    
    //科目を作るときにのみ呼ばれる
    func taskAddition() {
        //辞書型データを作成するためのUUID・DateComponentsを用意
        let dateComponents = generateDateComponents(arr: indexForButtons)
        let uuids = NotificationProcessing().createUUIDs()
        
        if classTitleTextField.text == "" {
            let alert: UIAlertController = UIAlertController(title: "科目名がありません", message: "科目名を入力してください", preferredStyle:  UIAlertController.Style.actionSheet)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                  (action: UIAlertAction!) -> Void in
                  print("OK")
              })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        if let classTitle = classTitleTextField.text {
            let appendedItem = registeredItem(classTitle: classTitle,
                                              arrForButtons: indexForButtons,
                                              description: descriptionTextView.text,
                                              ToggledDates: AddNotificationViewController.toggledItem,
                                              uuidAndDate: NotificationProcessing().createDictForIdAndDates(id: uuids, date: dateComponents))
            ClassListViewController.itemsForClassTableView.append(appendedItem)
        //通知をここで作成
        NotificationProcessing().createNotification(item: appendedItem)
        assesToggleItems(item: appendedItem, isToggled: appendedItem.ToggledDates.pub_Date_IsToggled, dictKey: "publish")
        assesToggleItems(item: appendedItem, isToggled: appendedItem.ToggledDates.view_Date_IsToggled, dictKey: "view")
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            print("pending request: \($0)")
        })
    }
    
    func taskEditing() {
        let dateComponents = generateDateComponents(arr: indexForButtons)
        let idAndDate = TaskRegisterViewController.inheritedItem.uuidAndDate
        let uuids = NotificationProcessing().extractUUIDs(dict: idAndDate)
        
        if let classTitle = classTitleTextField.text,
           var item = TaskRegisterViewController.inheritedItem,
           let inheritedIndex = ClassListViewController.indexForEditedItem {
            item.classTitle = classTitle
            item.arrForButtons = indexForButtons
            item.description = descriptionTextView.text
            item.ToggledDates = AddNotificationViewController.toggledItem
            item.uuidAndDate = NotificationProcessing().createDictForIdAndDates(id: uuids, date: dateComponents)
            //テーブルの同じ行に追加する↓
            ClassListViewController.itemsForClassTableView[inheritedIndex] = item
            NotificationProcessing().editNotification(item: item)
            assesToggleItems(item: item, isToggled: item.ToggledDates.pub_Date_IsToggled, dictKey: "publish")
            assesToggleItems(item: item, isToggled: item.ToggledDates.view_Date_IsToggled, dictKey: "view")
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            print("pending request: \($0)")
        })
    }
    
    func generateDateComponents(arr: [Int]) -> [DateComponents?] {
        let rawArr = NotificationProcessing().convertIntoRawIndex(arr: indexForButtons)
        let assessedIndex = NotificationProcessing().updateRawIndex(item: AddNotificationViewController.toggledItem, index: rawArr)
        let createdDates = NotificationProcessing().appendNotificationDates(arr: assessedIndex)
        return createdDates
    }
    
    func assesToggleItems(item: registeredItem,isToggled: Bool, dictKey: String) {
        switch isToggled {
        case true:
            //作ってるけどおなじ日時で更新されるだけ
            NotificationProcessing().createNotification(item: item)
        case false:
            //該当する通知を削除
            if let dictItem = item.uuidAndDate[dictKey]?.first {
                NotificationProcessing().deleteNotification(uuid: dictItem.key)
            }
        }
    }
    
    //initialize registration field
    func initRegistrationField() {
        classTitleTextField.text?.removeAll()
        indexForButtons = [0, 0, 0]
        publishedDateButton.setAttributedTitle(NSAttributedString(string: "公開日:\(DayOfTheWeek.allCases[indexForButtons[0]].rawValue)", attributes: attributes), for: .normal)
        viewingDeadlineButton.setAttributedTitle(NSAttributedString(string: "視聴期限:\(DayOfTheWeek.allCases[indexForButtons[1]].rawValue)", attributes: attributes), for: .normal)
        assignmentDeadlineButton.setAttributedTitle(NSAttributedString(string: "課題期限:\(DayOfTheWeek.allCases[indexForButtons[2]].rawValue)", attributes: attributes), for: .normal)
        descriptionTextView.text.removeAll()
        AddNotificationViewController.toggledItem.pub_Date_IsToggled = true
        // :TODO
    }
}

extension TaskRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension TaskRegisterViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
