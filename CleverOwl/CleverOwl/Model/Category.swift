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
let categoryDefaultColor = UIColor.white

struct Category: Codable{
    var name:String
    var color:Color
    
    static func getSample() -> [Category]{
        return [
            Category(name: categoryDefaultName, color: Color(categoryDefaultColor)),
            Category(name: "Work", color: .blue),
            Category(name: "Personal", color: .purple),
            Category(name: "Health", color: .red),
            Category(name: "Travel", color: .blue),
            Category(name: "Education", color: .purple),
        ]
    }
}


let keyForCategory = "Category.CleverOwl"

func saveCategory(_ category:Category){
    print("DEBUG: Category - Save")
    let data = try? JSONEncoder().encode(category)
    UserDefaults.standard.array(forKey: keyForCategory)
}

func loadCategory() -> [Category] {
    print("DEBUG: Category - load")
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
    print("DEBUG: Category - Delete")
    UserDefaults.standard.removeObject(forKey: keyForCategory)
}
