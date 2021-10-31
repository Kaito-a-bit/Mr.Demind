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
        pubDateLabel.text = model.published_Date.rawValue
        viewDateLabel.text = model.viewing_Deadline.rawValue
        assignDateLabel.text = model.assignment_Deadline.rawValue
    }
    
}
