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
    static var indexForEditedItem: Int!
    static var itemsForClassTableView: [registeredItems] = []
    static var savedItemsForClassTableView: [registeredItems]!
    var isTappedInitially: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "オンデマンド科目"
        if let restoredValues = userDataBase.restoreItemsForClassTableView() {
            ClassListViewController.itemsForClassTableView = restoredValues
        }
        self.classTableView.reloadData()
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        //登録ボタンからきたことを指定
        TaskRegisterViewController.fromWhere = .register
        transitionToRegister()
    }
    
    //func to update the database
    func updateDataBase() {
        ClassListViewController.savedItemsForClassTableView = ClassListViewController.itemsForClassTableView
        userDataBase.saveItemsForClassTableview(values: ClassListViewController.itemsForClassTableView)
    }
    
    func transitionToRegister() {
        taskRegisterVC.modalPresentationStyle = .pageSheet
        if let sheet = taskRegisterVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        taskRegisterVC.presentationController?.delegate = self
        self.present(taskRegisterVC, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isTappedInitially = !isTappedInitially
        self.classTableView.beginUpdates()
        self.classTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.classTableView.indexPathForSelectedRow?.row == indexPath.row {
            switch isTappedInitially {
            case false:
                return 216
            case true:
                return 90
            }
        } else {
            return 90
        }
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
            //編集ボタンからきたことを指定
            TaskRegisterViewController.fromWhere = .edit
            self.transitionToRegister()
            //値引き継ぎ
            TaskRegisterViewController.inheritedItem = ClassListViewController.itemsForClassTableView[indexPath.row]
            //インデックス引き継ぎ
            ClassListViewController.indexForEditedItem = indexPath.row
            completionHandler(true)
        }
        let action = UISwipeActionsConfiguration(actions: [editAction])
        action.performsFirstActionWithFullSwipe = false
        return action
    }
}

extension ClassListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        updateDataBase()
        self.classTableView.reloadData()
    }
}

