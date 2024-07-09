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
        iconCategory.image = UIImage(systemName: category.icon)
        iconCategory.tintColor = .white
        
        labelCategory.text = category.name
        
        self.backgroundColor = category.color.uiColor()
    }

}
