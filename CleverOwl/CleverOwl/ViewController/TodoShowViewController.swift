//
//  TodoShowViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/9/24.
//

import UIKit
import SwiftUI

class TodoShowViewController: UIViewController {
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelCategory: UILabel!
    
    @IBOutlet weak var iconCategory: UIImageView!
    
    @IBOutlet weak var textViewDescription: UITextView!

    @IBOutlet weak var labelDueDate: UILabel!
    
    @IBOutlet weak var labelCreateAt: UILabel!
    
    @IBOutlet weak var labelCompletedAt: UILabel!
    
    @IBOutlet weak var iconStatus: UIImageView!
    
    @IBOutlet weak var labelImportant: UILabel!
    
    var showTitle:String = ""
    var showDescription = ""
    var category = Category(name: categoryDefaultName, color: Color(categoryDefaultColor), icon: categoryDefaultIcon)
    var showDueDate = ""
    var showCreateAt = ""
    var showCompleteAt = ""
    var isImportant = false
    var isComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title
        labelTitle?.text = showTitle
        if self.isComplete {
            
            labelTitle.tintColor = UIColor.gray
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: showTitle)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length)
            )
            labelTitle.attributedText = attributeString
        }
        
        
        //Description
        //        adjustUITextViewHeight(arg: self.textViewDescription)
        textViewDescription?.text = showDescription
        
        
        //Important
        if self.isImportant {
            //Icon status
            iconStatus?.image = UIImage(systemName: "exclamationmark.circle.fill")
            iconStatus?.tintColor = .red
            
        } else {
            iconStatus?.removeFromSuperview()
            labelImportant?.removeFromSuperview()
        }
        
        
        //Category formatting
        if category.name != categoryDefaultName {
            let cadegoryLbl = category.name.trimmingCharacters(in: .whitespaces)
            labelCategory.text = "   \(cadegoryLbl)   "
            labelCategory.backgroundColor = category.color.uiColor()
            labelCategory.adjustsFontSizeToFitWidth = true
            labelCategory.minimumScaleFactor = 0.5
            labelCategory.numberOfLines = 1
            labelCategory.layer.masksToBounds = true
            labelCategory.layer.cornerRadius = 5
            iconCategory.image = UIImage(systemName: category.icon ?? categoryDefaultIcon)
            iconCategory.tintColor = category.color.uiColor()
            labelTitle.textColor = category.color.uiColor()
        } else {
            labelCategory?.removeFromSuperview()
        }
        
        labelDueDate?.text = showDueDate
        labelCreateAt?.text = showCreateAt
        labelCompletedAt?.text = showCompleteAt
        
    }
    
    
    @IBAction func Edit(_ sender: Any) {
        let alert = UIAlertController(title: "Not available in this version", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
