//
//  Category.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import Foundation
import UIKit
import SwiftUI

let categoryDefaultName = "Select a category"
let categoryDefaultValeu = "Uncategorized"
let categoryDefaultColor = UIColor.gray
let categoryDefaultIcon = "questionmark.square"

struct Category: Codable{
    var name:String
    var color:Color
    var icon:String
    
    static func getSample() -> [Category]{
        return [
            Category(name: categoryDefaultValeu, color: Color(categoryDefaultColor), icon:"questionmark.square"),
            Category(name: "iOS", color: .orange, icon: "iphone"),
            Category(name: "Web", color: .blue, icon: "desktopcomputer"),
            Category(name: "System Analysis", color: .red, icon: "doc.text"),
            Category(name: "UI/UX", color: .purple, icon: "pencil.and.outline"),
            Category(name: "Sample category", color: .green, icon: "trash"),
        ]
    }
}


let keyForCategory = "Category.CleverOwl"

func saveCategory(_ category:[Category]){
//    print("DEBUG: Category - Save")
    let data = try? JSONEncoder().encode(category)
    UserDefaults.standard.array(forKey: keyForCategory)
}

func loadCategory() -> [Category] {
//    print("DEBUG: Category - load")
    guard let data = UserDefaults.standard.data(forKey: keyForCategory) else {
        return Category.getSample()
    }
    do {
        return try JSONDecoder().decode([Category].self, from: data)
    } catch {
        return Category.getSample()
    }
}
func deleteCategory(){
//    print("DEBUG: Category - Delete")
    UserDefaults.standard.removeObject(forKey: keyForCategory)
}
