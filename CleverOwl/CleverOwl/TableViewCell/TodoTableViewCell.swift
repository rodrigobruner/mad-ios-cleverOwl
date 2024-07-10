//
//  TodoTableViewCell.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    var appSettings:AppSettings = AppSettings.defaultSettings()
    
    @IBOutlet weak var iconCategory: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var iconStatus: UIImageView!
    
    @IBOutlet weak var iconClock: UIImageView!
    
    @IBOutlet weak var labelDueDate: UILabel!
    
    @IBOutlet weak var labelCategory: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        labelTitle.text = nil
        labelTitle.attributedText = nil
        labelTitle.tintColor = .lightGray
        labelCategory?.backgroundColor = nil
        iconCategory.image = nil
        iconCategory.tintColor = .lightGray
        iconStatus?.image = nil
        iconStatus?.tintColor = .lightGray
        self.layer.borderColor = UIColor(named: "Secondary")?.cgColor
        iconClock.tintColor = .lightGray
        labelDueDate?.textColor = .lightGray
    }

    
    func set(todo: Todo) {
            
            labelTitle.text = todo.title
            
            let category = todo.category.name.trimmingCharacters(in: .whitespaces)
            labelCategory?.text = "   \(category)   "
        
            
            if todo.dueDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = appSettings.defaultDateFormat
                let formatedDate = dateFormatter.string(from: todo.dueDate!)
                labelDueDate?.text = formatedDate
            }
            formatCard(todo: todo)
        }
        
    func formatCard(todo: Todo) {
        
        

        if todo.category.name != categoryDefaultName {
            labelCategory?.backgroundColor = todo.category.color.uiColor()
            iconCategory.image = UIImage(systemName: todo.category.icon ?? categoryDefaultIcon)
            iconCategory.tintColor = todo.category.color.uiColor()
        } else {
            labelCategory?.removeFromSuperview()
        }
        
        labelDueDate?.textColor = .white
        iconClock?.tintColor = .white
        if let dueDate = todo.dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = appSettings.defaultDateFormat
            let formatedDate = dateFormatter.string(from: dueDate)
            labelDueDate?.text = formatedDate
            iconClock?.tintColor = .black
            labelDueDate?.tintColor = .black
            if let days = daysUntilDate(dueDate), days == 1 {
                iconClock?.tintColor = .red
                labelDueDate?.tintColor = .red
            }
        }


        iconStatus?.image = nil
        iconStatus?.tintColor = .white
        if todo.isImportant {
            iconStatus?.image = UIImage(systemName: "exclamationmark.circle.fill")
            iconStatus?.tintColor = .red
        }
        

        if todo.isComplete {
//            print("===================== Completed")
//            print(todo)
            self.layer.borderColor = UIColor.lightGray.cgColor
            labelTitle.textColor = UIColor.lightGray
            labelDueDate.textColor = UIColor.lightGray
            iconCategory.tintColor = .lightGray
            labelCategory.backgroundColor = .lightGray
            iconStatus.tintColor = .lightGray
            iconClock.tintColor = .lightGray
        } else {
            self.layer.borderColor = UIColor(named: "Secondary")?.cgColor
  
            labelTitle.textColor = UIColor.black
            labelDueDate.textColor = UIColor.black
            iconClock.tintColor = .black
            labelTitle.attributedText = NSAttributedString(string: todo.title)
            if todo.category.name != categoryDefaultName {
                iconCategory.tintColor = todo.category.color.uiColor()
                labelCategory?.backgroundColor = todo.category.color.uiColor()
            }
        }
    }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
                
            //Card
            self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            self.backgroundColor = UIColor.white
//            self.layer.borderWidth = 1
            
    //        self.layer.cornerRadius = 8
//            self.clipsToBounds = true
            
            //Card shadow
    //        self.layer.masksToBounds = false
    //        self.layer.shadowOffset = CGSizeMake(0, 0)
    //        self.layer.shadowColor = UIColor.black.cgColor
    //        self.layer.shadowOpacity = 0.9
    //        self.layer.shadowRadius = 2
            
            
            
            if (labelCategory != nil) {
                //Category
                labelCategory?.adjustsFontSizeToFitWidth = true
                labelCategory?.minimumScaleFactor = 0.5
                labelCategory?.numberOfLines = 1
                labelCategory?.layer.masksToBounds = true
                labelCategory?.layer.cornerRadius = 5
            }
            
        }

}
