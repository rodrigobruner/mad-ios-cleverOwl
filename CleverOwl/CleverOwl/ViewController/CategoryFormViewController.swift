//
//  CategoryFormViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import UIKit

class CategoryFormViewController: UIViewController, UIColorPickerViewControllerDelegate {

    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var buttonColor: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
      
    }
    
}
