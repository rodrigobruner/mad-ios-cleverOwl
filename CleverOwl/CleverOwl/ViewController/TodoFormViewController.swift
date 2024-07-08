//
//  TodoFormViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import UIKit
import SwiftUI

class TodoFormViewController: UIViewController {
    
    var appSettings:AppSettings = AppSettings.defaultSettings()
    
    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var textDescription: UITextField!
        
    @IBOutlet weak var switchImportant: UISwitch!
    
    @IBOutlet weak var buttonSelectCategory: UIButton!
    
    @IBOutlet weak var textDueDate: UITextField!
    
    
    //Start Select category
    let transparentView = UIView()
    
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var categories = [Category]()
    
    //Satat due date
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryCell")
        
        createDatepicker()
        
        reload()
    }
    
    func reload(){
        categories = loadCategory()
        //        print(categories)
        
        appSettings = loadAppSettings()
        //        print(appSettings)
    }
    
    
    //Select category ------------------------------
    func addTransparentView(frames: CGRect){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        //Add tableView
        tableView.frame = CGRect(x: frames.origin.x,
                                 y: frames.origin.y + frames.height,
                                 width: frames.width,
                                 height: 0)
        tableView.layer.cornerRadius = 5
        self.view.addSubview(tableView)
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        
        //Animeation
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y + frames.height + 5,
                                          width: frames.width,
                                          height: CGFloat(self.categories.count*50))
            
        }, completion: nil)
    }
    
    @objc func removeTransparentView(){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let frames = self.selectedButton.frame
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y + frames.height,
                                          width: frames.width,
                                          height: 0)
            
        }, completion: nil)
    }
    
    @IBAction func selectCategory(_ sender: Any) {
        self.selectedButton = buttonSelectCategory
        addTransparentView(frames: buttonSelectCategory.frame)
    }
    
    
    //Date Picker -----------------------------------
    func createDatepicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        textDueDate.inputView = datePicker
        textDueDate.inputAccessoryView = createToolbar()
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([btnDone], animated: true)
        
        return toolbar
    }
    
    @objc func donePressed() {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = appSettings.defaultDateFormat
        
        self.textDueDate.text = dataFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    //Save task -----------------------------------
    @IBAction func saveTask(_ sender: Any) {
        let uid = UUID().uuidString
        
        let title = textTitle.text
        
        if title!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let alert = UIAlertController(title: "Title field required", message: "Please enter a title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let description = textDescription.text ?? ""
        
        let category = Category(name: (buttonSelectCategory.titleLabel?.text ?? categoryDefaultName) ,
                                color: Color(buttonSelectCategory.backgroundColor ?? categoryDefaultColor))
        
        let dueDateText = textDueDate.text ?? ""
        
        let isImportant = switchImportant.isOn
        
        var dueDate:Date? = nil
        
        if dueDateText != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = appSettings.defaultDateFormat
            dueDate = dateFormatter.date(from:dueDateText)!
        }
        
        let todo = Todo(uid: uid,
                        title: title ?? "",
                        description: description,
                        category: category,
                        createAt: Date(),
                        dueDate: dueDate,
                        isComplete: false,
                        isImportant: isImportant)
        var todoList = loadTodoList()
        todoList.append(todo)
        saveTodoList(todoList)
        
       //Update VC
//        if let vc = storyboard?.instantiateViewController(identifier: "todoListScreen") as? TodoListTableViewController {
//            //vc.AddNewTask(todo: todo)
//            vc.todoList.append(todo)
//            let newIndexPath = IndexPath(row: vc.todoList.count-1, section: 0)
//            vc.tableView.insertRows(at: [newIndexPath], with: .fade)
//            saveTodoList(vc.todoList)
//        }
        NotificationCenter.default.post(name: NSNotification.Name("DidUpdateData"), object: nil)
        resetForm()
        self.tabBarController!.selectedIndex = 0
    }
    
    
    func resetForm(){
        textTitle.text = ""
        textDescription.text = ""
        switchImportant.isOn = false
        buttonSelectCategory.backgroundColor = categoryDefaultColor
        buttonSelectCategory.titleLabel?.text = categoryDefaultName
        buttonSelectCategory.tintColor = .blue
        textDueDate.text = ""
    }
}


extension TodoFormViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        var category = categories[indexPath.row]
//        print(indexPath.row)

        cell.textLabel?.text = category.name
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension TodoFormViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        buttonSelectCategory.setTitle(category.name, for: .normal)
        buttonSelectCategory.backgroundColor = category.color.uiColor()
        buttonSelectCategory.tintColor = .white
        if category.color.uiColor() == .white {
            buttonSelectCategory.tintColor = .blue
        }
        removeTransparentView()
    }
}
