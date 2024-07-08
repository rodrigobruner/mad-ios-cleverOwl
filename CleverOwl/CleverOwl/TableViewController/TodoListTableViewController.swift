//
//  TodoListTableViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import UIKit
import SwiftUI

class TodoListTableViewController: UITableViewController {
    
    var todoList:[Todo] = []
    
    var appSettings:AppSettings = AppSettings.defaultSettings()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddTask), name: NSNotification.Name("DidUpdateData"), object: nil)
    }
    
    //Observe changes in todoList
    @objc func handleAddTask() {
        self.todoList = loadTodoList()
        let newIndexPath = IndexPath(row: self.todoList.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .fade)
//        print("Update")
//        print(self.todoList.last)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload(){
        todoList = loadTodoList()
//        print(todoList)
        
        appSettings = loadAppSettings()
//        print(appSettings)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        print("Add")
        tabBarController!.selectedIndex = 1
    }
    
    
    //Return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return number of Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo:Todo = todoList[indexPath.row]
        
        cell.textLabel?.text = todo.title
        return cell
    }
}
