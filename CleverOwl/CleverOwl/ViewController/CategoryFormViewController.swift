//
//  CategoryFormViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import UIKit
import SwiftUI


class CategoryFormViewController: UIViewController, UIColorPickerViewControllerDelegate {

    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var buttonColor: UIButton!
    
    @IBOutlet weak var buttonIcon: UIButton!
    
    var categoryList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList = loadCategory()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "primary") ?? .blue]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveCategory(_ sender: Any) {
        
        let name = textName.text
        if name!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let alert = UIAlertController(title: "Name field required", message: "Please enter a name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let color = Color(buttonColor.backgroundColor!)
        let icon = categoryDefaultIcon
        let category = Category(name: name!, color: color, icon: icon)
        categoryList.append(category)
        NotificationCenter.default.post(name: NSNotification.Name("DidUpdateCategoryData"), object: nil)
        self.navigationController?.popViewController(animated: true)    }
    

    @IBAction func selectColor(_ sender: Any) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.isModalInPresentation = true
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        buttonColor.backgroundColor = color
    }
    
    
    
    @IBAction func selectIcon(_ sender: Any) {
        let alert = UIAlertController(title: "Not available in this version", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
}

