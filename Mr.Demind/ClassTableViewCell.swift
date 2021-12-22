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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(from model: registeredItem) {
        classTitle.text = model.classTitle
        pubDateLabel.text = "公開日: \(DayOfTheWeek.allCases[model.arrForButtons[0]].rawValue)"
        viewDateLabel.text = "視聴期限: \(DayOfTheWeek.allCases[model.arrForButtons[1]].rawValue)"
        assignDateLabel.text = "課題期限: \(DayOfTheWeek.allCases[model.arrForButtons[2]].rawValue)"
        
        pubDateLabel.textColor = model.ToggledDates.pub_Date_IsToggled ? UIColor.black : UIColor.darkGray
        viewDateLabel.textColor = model.ToggledDates.pub_Date_IsToggled ? UIColor.black : UIColor.darkGray
        if let description = model.description {
            descriptionLabel.text = description.isEmpty ? "No description" : description
        }
    }
}
