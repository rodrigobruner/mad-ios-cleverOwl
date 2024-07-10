//
//  SelectCategoryTableViewCell.swift
//  CleverOwl
//
//  Created by user228347 on 7/9/24.
//

import UIKit

class SelectCategoryTableViewCell: UITableViewCell {
    var iconCategory: UIImageView!
    var labelCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        // Inicialização e configuração do UIImageView
        iconCategory = UIImageView()
        iconCategory.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconCategory)
        
        // Inicialização e configuração do UILabel
        labelCategory = UILabel()
        labelCategory.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelCategory)
        
        // Constraints para iconCategory
        NSLayoutConstraint.activate([
            iconCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconCategory.widthAnchor.constraint(equalToConstant: 24),
            iconCategory.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Constraints para labelCategory
        NSLayoutConstraint.activate([
            labelCategory.leadingAnchor.constraint(equalTo: iconCategory.trailingAnchor, constant: 8),
            labelCategory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Configurações adicionais
        iconCategory.tintColor = .white
        labelCategory.textColor = .white
    }
    
    func set(category: Category) {
        // Sua lógica existente para configurar a célula
    }
}
