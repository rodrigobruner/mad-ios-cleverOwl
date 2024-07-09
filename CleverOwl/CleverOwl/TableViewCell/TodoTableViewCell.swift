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
        
        func formatCard(todo:Todo) {
            
            //Category formatting
            if todo.category.name != categoryDefaultName {
                labelCategory?.backgroundColor = todo.category.color.uiColor()
            } else {
                labelCategory?.removeFromSuperview()
            }
            iconCategory.image = UIImage(systemName: todo.category.icon)
            iconCategory.tintColor = todo.category.color.uiColor()
            
            print(" DUE date \(todo.dueDate)")
            //Date formatting
            if todo.dueDate != nil {
                if todo.dueDate != todo.createAt, let days = daysUntilDate(todo.dueDate!) {
                    if days == 1 {
                        iconClock?.tintColor = .red
                        labelDueDate?.tintColor = .red
                    }
                } else {
                    labelDueDate?.removeFromSuperview()
                    iconClock?.removeFromSuperview()
                }
            } else {
                print("DueDate=Nil")
                labelDueDate?.removeFromSuperview()
                iconClock?.removeFromSuperview()
            }

            
            //Icon formatting
            if todo.isImportant {
                //Icon status
                iconStatus?.image = UIImage(systemName: "exclamationmark.circle.fill")
                iconStatus?.tintColor = .red
                self.layer.borderColor = UIColor(named: "Secondary")?.cgColor
            } else {
                if (iconStatus != nil) {
                    iconStatus.removeFromSuperview()
                }
            }
            
            if todo.isComplete {
                self.layer.borderColor = UIColor.gray.cgColor
                labelTitle.tintColor = UIColor.gray
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: todo.title)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length)
                    )
            
                
                
                labelTitle.attributedText = attributeString
                
            }
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
                
            
            //Remove selection style
    //        self.selectionStyle = .none;
            
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
