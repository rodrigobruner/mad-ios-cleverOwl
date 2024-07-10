//
//  CategoryTableViewCell.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var iconCategory: UIImageView!
    
    @IBOutlet weak var labelCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(category:Category){
        if category != nil {
            
            let categoryIcon: String = category.icon ?? categoryDefaultIcon
            if let image = UIImage(systemName: categoryIcon) {
                iconCategory?.image = image
            } else {

                iconCategory.image = UIImage(systemName: categoryDefaultIcon)
            }

            iconCategory.tintColor = .white
            
            labelCategory.text = category.name
            labelCategory.textColor = .white
            
            self.backgroundColor = category.color.uiColor()
        }
    }

}
