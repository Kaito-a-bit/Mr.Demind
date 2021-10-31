//
//  ClassTableViewCell.swift
//  Mr.Demind
//
//  Created by 荒井海斗 on 2021/10/31.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var viewDateLabel: UILabel!
    @IBOutlet weak var assignDateLabel: UILabel!
    
    func configure(from model: registeredItems) {
        classTitle.text = model.classTitle
        pubDateLabel.text = "公開日: \(model.published_Date.rawValue)"
        viewDateLabel.text = "視聴期限: \(model.viewing_Deadline.rawValue)"
        assignDateLabel.text = "課題期限: \(model.assignment_Deadline.rawValue)"
    }
    
}
