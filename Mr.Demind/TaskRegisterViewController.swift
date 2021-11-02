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
    
    var indexForButtons: [Int] = [0, 0, 0] //「-」を指定
    static var fromWhere: ViewsLeftBehind = .register
    
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
            print("hello from edit button")
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        taskAddition()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishedDateButton(_ sender: Any) {
        indexForButtons[0] += 1
        publishedDateButton.setAttributedTitle(NSAttributedString(string: "公開日:\(DayOfTheWeek.allCases[indexForButtons[0]].rawValue)", attributes: attributes), for: .normal)
        indexForButtons[0] = indexForButtons[0] == 8 ? 0 : indexForButtons[0]
    }
    
    
    @IBAction func viewingDeadlineButton(_ sender: Any) {
        indexForButtons[1] += 1
        viewingDeadlineButton.setAttributedTitle(NSAttributedString(string: "視聴期限:\(DayOfTheWeek.allCases[indexForButtons[1]].rawValue)", attributes: attributes), for: .normal)
        indexForButtons[1] = indexForButtons[1] == 8 ? 0 : indexForButtons[1]
    }
    
    @IBAction func assignmentDeadlineButton(_ sender: Any) {
        indexForButtons[2] += 1
        assignmentDeadlineButton.setAttributedTitle(NSAttributedString(string: "課題期限:\(DayOfTheWeek.allCases[indexForButtons[2]].rawValue)", attributes: attributes), for: .normal)
        indexForButtons[2] = indexForButtons[2] == 8 ? 0 :  indexForButtons[2]
    }
    
    func taskAddition() {
        if let classTitle = classTitleTextField.text {
            ClassListViewController.itemsForClassTableView.append(
                registeredItems(classTitle: classTitle,
                                arrForButtons: indexForButtons,
                                description: descriptionTextView.text))
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
