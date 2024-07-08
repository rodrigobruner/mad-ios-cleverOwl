//
//  TodoListTableViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var todoList:[Todo] = []
    
    var appSettings:AppSettings = AppSettings.defaultSettings()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    func reload(){
        todoList = loadTodoList()
//        print(todoList)
        
        appSettings = loadAppSettings()
//        print(appSettings)
        
        tableView.reloadData()
    }
    
    func AddNewTask(todo:Todo){
        print(todo)
        self.todoList.append(todo)
        saveTodoList(self.todoList)
        reload()
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



