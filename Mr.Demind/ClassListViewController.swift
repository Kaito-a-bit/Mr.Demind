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
}

extension ClassListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print(ClassListViewController.itemsForClassTableView)
        //データベース保存
        ClassListViewController.savedItemsForClassTableView = ClassListViewController.itemsForClassTableView
        userDataBase.saveItemsForClassTableview(values: ClassListViewController.itemsForClassTableView)
        self.classTableView.reloadData()
    }
}

