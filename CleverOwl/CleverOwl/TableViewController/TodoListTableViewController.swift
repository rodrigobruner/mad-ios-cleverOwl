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
    
    var categoryList: [Category] = []
    
    var organizedTodoList:[Todo] = []
    
    var groupedTodos: [String: [Todo]] = [:]
    var categoryKeys: [String] = []
    
    var appSettings:AppSettings = AppSettings.defaultSettings()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddTask), name: NSNotification.Name("DidUpdateData"), object: nil)
    }
    
    
    //Observe new itens
    @objc func handleAddTask() {
        self.todoList = loadTodoList()
        
        if appSettings.grupedByCategory {
            reload()
            let sectionName = categoryKeys.first(where: {$0 == todoList.last?.category.name})
            let section = categoryKeys.firstIndex(of: sectionName!)
            let row = groupedTodos[sectionName!]?.count ?? 0
            
            print("DEBUG ----------------------------------------------")
            print(categoryKeys)
            print("----------------------------------------------------")
            print(section)
            print("----------------------------------------------------")
            print(row)
            print("----------------------------------------------------")
            print(groupedTodos[sectionName!])
            
            
            let newIndexPath = IndexPath(row: row, section: section!)
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        } else {
            let newIndexPath = IndexPath(row: self.todoList.count-1, section: 0)
            reload()
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        }
//        print("Update")
//        print(self.todoList.last)
    }
    
    //Remove observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //Update data
    func reload(){
        todoList = loadTodoList()
//        print(todoList)
        
        appSettings = loadAppSettings()
        print(appSettings)
        
        if appSettings.grupedByCategory {
            groupedTodos = Dictionary(grouping: loadTodoList(), by: { $0.category.name })
            categoryKeys = groupedTodos.keys.sorted()
        } else {
            
            var cache:[Todo] = todoList
            
            //Order by due date
            cache.sort(by: { $0.dueDate?.compare(($1.dueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: $1.createAt))!) == .orderedDescending })
            
            if appSettings.importantFirst {
                cache.sort{ $0.isImportant && !$1.isImportant }
            }
            
            if appSettings.showCompletedTasks {
                //Completed at the end
                cache.sort{ !$0.isComplete && $1.isComplete }
            }
//            print(cache)
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
    
    
    //Add button
    @IBAction func addNewTask(_ sender: Any) {
//        print("add")
        self.tabBarController!.selectedIndex = 1
    }
    
    
    // Table View - data source ##################
    
    //Return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if appSettings.grupedByCategory {
            return categoryKeys.count
        }
        return 1
    }
    
    //Return name of sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if appSettings.grupedByCategory {
            if categoryKeys[section] == categoryDefaultName {
                return categoryDefaultValeu
            }
            return categoryKeys[section]
        }
        return ""
    }
    
    //Return number of Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appSettings.grupedByCategory {
            let category = self.categoryKeys[section]
            return self.groupedTodos[category]?.count ?? 0
        }
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        
        var todo:Todo
    
        if appSettings.grupedByCategory {
            let category = categoryKeys[indexPath.section]
            todo = groupedTodos[category]![indexPath.row]
        } else {
            todo = todoList[indexPath.row]
        }
        
        cell.set(todo: todo)
        return cell
    }
    
    
    // Table View - delegate ##################
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view, complete in
            tableView.beginUpdates()
            
            if self.appSettings.grupedByCategory {
                
                // Remove from todo List
                let todo = self.groupedTodos[self.categoryKeys[indexPath.section]]![indexPath.row]
                let todoListKey = self.todoList.firstIndex(where: { $0.uid == todo.uid });
                if todoListKey! > -1 {
                    self.todoList[todoListKey!].isComplete = true
                }
                
                self.groupedTodos[todo.category.name]?[indexPath.row].isComplete = true
                
//                print("DEBUG -----------------------------------")
//                print(todo)
//                print("-----------------------------------------")
//                print("Todo list Key: \(todoListKey)")
//                print(todoList[todoListKey!])
//                print("row:\(indexPath.row) | Section:\(indexPath.section)")
                
                
                if !self.appSettings.showCompletedTasks {
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
                    
                    let category = self.categoryKeys[indexPath.section]
                    guard var tasksInCategory = self.groupedTodos[category] else { return }
                    if tasksInCategory.isEmpty {
                        self.groupedTodos.removeValue(forKey: category)
                        self.categoryKeys = self.groupedTodos.keys.sorted()
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                    }
                }
            } else {
                self.todoList[indexPath.row].completedAt = Date()
                self.todoList[indexPath.row].isComplete = true;
                self.reload()
            }
            saveTodoList(self.todoList)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            
            if appSettings.grupedByCategory {
                
                // Remove from todo List
                let todo = groupedTodos[categoryKeys[indexPath.section]]![indexPath.row]
                let todoListKey = todoList.firstIndex(where: { $0.uid == todo.uid });
                if todoListKey! > -1 {
                    todoList.remove(at: todoListKey!)
                }
                
                groupedTodos[todo.category.name]?.remove(at: indexPath.row)
                
//                print("DEBUG -----------------------------------")
//                print(todo)
//                print("-----------------------------------------")
//                print("Todo list Key: \(todoListKey)")
//                print(todoList[todoListKey!])
//                print("row:\(indexPath.row) | Section:\(indexPath.section)")
                
                
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
                
                let category = categoryKeys[indexPath.section]
                guard var tasksInCategory = groupedTodos[category] else { return }
                if tasksInCategory.isEmpty {
                    groupedTodos.removeValue(forKey: category)
                    categoryKeys = groupedTodos.keys.sorted()
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
                
            } else {
                todoList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            saveTodoList(todoList)
            tableView.endUpdates()
        }
    }
}
