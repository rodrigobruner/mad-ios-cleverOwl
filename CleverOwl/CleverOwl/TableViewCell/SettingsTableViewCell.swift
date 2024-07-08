//
//  SettingsTableViewCell.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconContainer: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var labelSetting: UILabel!
    
    var settingOprion:SettingsOption = SettingsOption(title: "", handler: {})
    
    var isASwitch:Bool = false
    


    private let mySwitch:UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        mySwitch.addTarget(self, action: #selector(switchHandler(_:)), for: .valueChanged)
        return mySwitch
    }()
    
    @objc func switchHandler(_ param:UISwitch){
        self.settingOprion.handler()
    }
    
    func set(option: SettingsOption){
        
        self.settingOprion = option
        
        labelSetting.text = option.title
        iconImageView.image = option.icon
        iconContainer.backgroundColor = option.iconBackgroundColor
        
        isASwitch = option.isASwitch
        if isASwitch {
            mySwitch.isOn = option.isOn
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isASwitch {
            self.contentView.addSubview(mySwitch)
            self.accessoryType = .none
        } else {
            self.accessoryType = .disclosureIndicator
        }
        let containerSize: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: containerSize, height: containerSize)
        
        iconImageView.tintColor = .white
        
        iconImageView.center = iconContainer.center
        
        let imageSize: CGFloat = containerSize/1.5
        iconImageView.frame = CGRect(x: (containerSize-imageSize)/2, y: (containerSize-imageSize)/2, width: imageSize, height: imageSize)
        
        
        if isASwitch {
            mySwitch.sizeToFit()
            mySwitch.frame = CGRect(x: contentView.frame.size.width - mySwitch.frame.size.width - 20,
                                    y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
                                    width: mySwitch.frame.size.width,
                                    height: mySwitch.frame.size.height)
        }
        
        labelSetting.frame = CGRect(x: 25 + iconContainer.frame.size.width,
                                    y: 0,
                                    width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
                                    height: contentView.frame.size.height)
    }
}
