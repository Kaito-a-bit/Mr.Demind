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
    
    var stateForPublishedDate: DayOfTheWeek? = .None
    var stateForViewingDeadline: DayOfTheWeek? = .None
    var stateForAssignmentDeadline: DayOfTheWeek? = .None
    var indexForPD = 0
    var indexForVD = 0
    var indexForAD = 0
    
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont.systemFont(ofSize: 12, weight: .medium)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTitleTextField.delegate = self
        initRegistrationField()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        taskAddition()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishedDateButton(_ sender: Any) {
        stateForPublishedDate = DayOfTheWeek.allCases[indexForPD]
        if let stateForPublishedDate = stateForPublishedDate {
            publishedDateButton.setAttributedTitle(NSAttributedString(string: "公開日:\(stateForPublishedDate.rawValue)", attributes: attributes), for: .normal)
        }
        indexForPD += 1
        indexForPD = indexForPD == 8 ? 0 : indexForPD
    }
    
    
    @IBAction func viewingDeadlineButton(_ sender: Any) {
        stateForViewingDeadline = DayOfTheWeek.allCases[indexForVD]
        if let stateForViewingDeadline = stateForViewingDeadline {
            viewingDeadlineButton.setAttributedTitle(NSAttributedString(string: "視聴期限:\(stateForViewingDeadline.rawValue)", attributes: attributes), for: .normal)
        }
        indexForVD += 1
        indexForVD = indexForVD == 8 ? 0 : indexForVD
    }
    
    @IBAction func assignmentDeadlineButton(_ sender: Any) {
        stateForAssignmentDeadline = DayOfTheWeek.allCases[indexForAD]
        if let stateForAssignmentDeadline = stateForAssignmentDeadline {
            assignmentDeadlineButton.setAttributedTitle(NSAttributedString(string: "課題期限:\(stateForAssignmentDeadline.rawValue)", attributes: attributes), for: .normal)
        }
        indexForAD += 1
        indexForAD = indexForAD == 8 ? 0 :  indexForAD
    }
    
    func taskAddition() {
        if let classTitle = classTitleTextField.text,
           let stateForPublishedDate = stateForPublishedDate,
           let stateForViewingDeadline = stateForViewingDeadline,
           let stateForAssignmentDeadline = stateForAssignmentDeadline {
            ClassListViewController.itemsForClassTableView.append(
                registeredItems(classTitle: classTitle,
                                published_Date: stateForPublishedDate,
                                viewing_Deadline: stateForViewingDeadline,
                                assignment_Deadline: stateForAssignmentDeadline,
                                description: descriptionTextView.text))
        }
    }
    
    //initialize registration field
    func initRegistrationField() {
        classTitleTextField.text?.removeAll()
        stateForPublishedDate = .None
        stateForViewingDeadline = .None
        stateForAssignmentDeadline = .None
        if let stateForPublishedDate = stateForPublishedDate,
           let stateForViewingDeadline = stateForViewingDeadline,
           let stateForAssignmentDeadline = stateForAssignmentDeadline {
            publishedDateButton.setAttributedTitle(NSAttributedString(string: "公開日:\(stateForPublishedDate.rawValue)", attributes: attributes), for: .normal)
            viewingDeadlineButton.setAttributedTitle(NSAttributedString(string: "視聴期限:\(stateForViewingDeadline.rawValue)", attributes: attributes), for: .normal)
            assignmentDeadlineButton.setAttributedTitle(NSAttributedString(string: "課題期限:\(stateForAssignmentDeadline.rawValue)", attributes: attributes), for: .normal)
        }
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
        initRegistrationField()
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
