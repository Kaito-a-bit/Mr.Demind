//
//  ViewController.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/26.
//

import UIKit

class ClassListViewController: UIViewController {
    
    @IBOutlet weak var classTableView: UITableView!
    
    let userDataBase = UserDataBase()
    let taskRegisterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Identifiers.idForTaskRegisterVC) as! TaskRegisterViewController
    static var itemsForClassTableView: [registeredItems] = []
    static var savedItemsForClassTableView: [registeredItems]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "オンデマンド科目"
        if let restoredValues = userDataBase.restoreItemsForClassTableView() {
            ClassListViewController.itemsForClassTableView = restoredValues
        }
        self.classTableView.reloadData()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        taskRegisterVC.modalPresentationStyle = .pageSheet
        if let sheet = taskRegisterVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        taskRegisterVC.presentationController?.delegate = self
        taskRegisterVC.initRegistrationField()
        self.present(taskRegisterVC, animated: true, completion: nil)
    }
    
    //func to update the database
    func updateDataBase() {
        ClassListViewController.savedItemsForClassTableView = ClassListViewController.itemsForClassTableView
        userDataBase.saveItemsForClassTableview(values: ClassListViewController.itemsForClassTableView)
    }
}

extension ClassListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClassListViewController.itemsForClassTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classTableView.dequeueReusableCell(withIdentifier: Identifiers.idForClassTableViewCell, for: indexPath) as! ClassTableViewCell
        let item = ClassListViewController.itemsForClassTableView[indexPath.row]
        cell.configure(from: item)
        return cell
    }
    
    //enable slide from the right side.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "削除") { action, view, completionHandler in
            ClassListViewController.itemsForClassTableView.remove(at: indexPath.row)
            self.classTableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateDataBase()
            completionHandler(true)
        }
        let action = UISwipeActionsConfiguration(actions: [deleteAction])
        action.performsFirstActionWithFullSwipe = false
        return action
    }
    
    //enable slide from the left side.
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "編集") { action, view, completionHandler in
          print("編集ボタンが押されたよ")
            completionHandler(true)
        }
        let action = UISwipeActionsConfiguration(actions: [editAction])
        action.performsFirstActionWithFullSwipe = false
        return action
    }
}

extension ClassListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print(ClassListViewController.itemsForClassTableView)
        updateDataBase()
        self.classTableView.reloadData()
    }
}

