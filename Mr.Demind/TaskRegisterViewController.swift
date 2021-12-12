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
        switch TaskRegisterViewController.fromWhere {
        case .register:
            taskAddition()
            self.dismiss(animated: true, completion: nil)
        case .edit:
            //ここでClassListViewControllerから取ってきた情報を元の場所に戻したい。
            taskEditing()
            self.dismiss(animated: true, completion: nil)
        }
        print(ClassListViewController.itemsForClassTableView)
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
        let dateComponents = generateDateComponents(arr: indexForButtons)
        let uuids = NotificationProcessing().createUUIDs()
        
        
        
        if let classTitle = classTitleTextField.text {
            let appendedItem = registeredItem(classTitle: classTitle,
                                              arrForButtons: indexForButtons,
                                              description: descriptionTextView.text,
                                              ToggledDates: AddNotificationViewController.toggledItem,
                                              uuidAndDate: NotificationProcessing().createDictForIdAndDates(id: uuids, date: dateComponents))
            ClassListViewController.itemsForClassTableView.append(appendedItem)
            NotificationProcessing().addNotification(item: appendedItem)
        }
    }
    
    func taskEditing() {
        let arr = NotificationProcessing().convertIntoRawIndex(arr: indexForButtons)
        if let classTitle = classTitleTextField.text,
           var item = TaskRegisterViewController.inheritedItem,
           let inheritedIndex = ClassListViewController.indexForEditedItem {
            item.classTitle = classTitle
            item.arrForButtons = indexForButtons
            item.description = descriptionTextView.text
            item.ToggledDates = AddNotificationViewController.toggledItem
            item.NotificationDates = NotificationProcessing().appendNotificationDates(arr: arr)
            ClassListViewController.itemsForClassTableView[inheritedIndex] = item
        }
    }
    
    func generateDateComponents(arr: [Int]) -> [DateComponents?]{
        let arr = NotificationProcessing().convertIntoRawIndex(arr: indexForButtons)
        let createdDates = NotificationProcessing().appendNotificationDates(arr: arr)
        return createdDates
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
