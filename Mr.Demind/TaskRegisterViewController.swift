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
    
  
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func registerButton(_ sender: Any) {
//    }
    var stateForPublishedDate: DayOfTheWeek?
    var stateForViewingDeadline: DayOfTheWeek?
    var stateForAssignmentDeadline: DayOfTheWeek?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTitleTextField.delegate = self
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
}


extension TaskRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
