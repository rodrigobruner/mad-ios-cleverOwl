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
    var filteredTodos: [Todo] = []
    
    var categoryList: [Category] = []
    
    var organizedTodoList:[Todo] = []
    
    var groupedTodos: [String: [Todo]] = [:]
    var categoryKeys: [String] = []
    
    var appSettings:AppSettings = AppSettings.defaultSettings()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "primary") ?? .blue]
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddTask), name: NSNotification.Name("DidUpdateData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange), name: NSNotification.Name("SettingsHaveChanged"), object: nil)
    }
    
    //Add new task
    @objc func handleAddTask() {
        self.todoList = loadTodoList()
        if appSettings.grupedByCategory {
            let lastCategoryName = todoList.last?.category.name
            let sectionName = categoryKeys.first(where: {$0 == lastCategoryName})
            
            var section = 0
            var row = 0
            if sectionName == nil {
                categoryKeys.append((todoList.last?.category.name)!)
                groupedTodos[(todoList.last?.category.name)!] = [todoList.last!]
                
                self.tableView.beginUpdates()
                section = categoryKeys.count - 1
                self.tableView.insertSections(IndexSet(integer: section), with: .automatic)
                self.tableView.insertRows(at: [IndexPath(row: row, section: section)], with: .fade)
                self.tableView.endUpdates()
                
            } else {
                section = categoryKeys.firstIndex(of: sectionName!)!
                row = groupedTodos[sectionName!]?.count ?? 0
                
                groupedTodos[sectionName!]?.append(todoList.last!)
                let newIndexPath = IndexPath(row: row, section: section)
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        } else {
            let newIndexPath = IndexPath(row: self.todoList.count-1, section: 0)
            self.tableView.reloadData()
        }
    }
    
    
    @objc func handleSettingsChange(){
        print("Change config")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //Remove observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //Update data
    func reload() {
        todoList = loadTodoList()
        appSettings = loadAppSettings()
        categoryList = loadCategory()
        filteredTodos = todoList.filter { !$0.isComplete }
        
        if appSettings.grupedByCategory {
            groupedTodos = Dictionary(grouping: todoList, by: { $0.category.name })
            categoryKeys = groupedTodos.keys.sorted()
            
            for (category, todos) in groupedTodos {
                groupedTodos[category] = todos.sorted { (todo1, todo2) in
                    let dueDate1 = todo1.dueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: todo1.createAt)!
                    let dueDate2 = todo2.dueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: todo2.createAt)!
                    return dueDate1 < dueDate2
                }
            }

            // 2. Se importantFirst está habilitado, ordenar por importância
            if appSettings.importantFirst {
                for (category, todos) in groupedTodos {
                    groupedTodos[category] = todos.sorted(by: { $0.isImportant && !$1.isImportant })
                }
            }

            // 3. Se showCompletedTasks está habilitado, mover tarefas concluídas para o final
            if appSettings.showCompletedTasks {
                for (category, todos) in groupedTodos {
                    groupedTodos[category] = todos.sorted(by: { !$0.isComplete && $1.isComplete })
                }
            }
        } else {
            var cache: [Todo] = todoList
            
            // Sort by due date, placing items without a due date last
            cache.sort { (todo1, todo2) in
                let dueDate1 = todo1.dueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: todo1.createAt)!
                let dueDate2 = todo2.dueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: todo2.createAt)!
                return dueDate1 < dueDate2
            }
            
            // If importantFirst is enabled, sort by importance
            if appSettings.importantFirst {
                cache = cache.sorted(by: { $0.isImportant && !$1.isImportant })
            }
            
            // If showCompletedTasks is enabled, move completed tasks to the end
            if appSettings.showCompletedTasks {
                cache = cache.sorted(by: { !$0.isComplete && $1.isComplete })
            }
            
            todoList = cache
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
        
        if !appSettings.showCompletedTasks {
            return filteredTodos.count
        }
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    //Custom header on section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        if appSettings.grupedByCategory {
            header.backgroundColor = .white
            
            let categoryName = self.categoryKeys[section]
            let category = categoryList.first(where: {$0.name == categoryName})
            
            var width = 0
            
            if category?.icon != "" {
                width = 25
                let imageView = UIImageView(image: UIImage(systemName: category?.icon ?? categoryDefaultIcon))
                imageView.tintColor = category?.color.uiColor()
                imageView.contentMode = .scaleAspectFit
                header.addSubview(imageView)
                imageView.frame = CGRect(x: 20, y: -8, width: width, height: 25)
            }
            let label = UILabel(frame: CGRect(x: 50 , y: -20,
                                              width: header.frame.size.width-30,
                                              height: header.frame.size.height-10))
            header.addSubview(label)
            label.text = category?.name
            label.font = .systemFont(ofSize: 22, weight: .bold)
            label.textColor = category?.color.uiColor()
        }
            return header
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        
        var todo:Todo
    
        if appSettings.grupedByCategory {
            let category = categoryKeys[indexPath.section]
            todo = groupedTodos[category]![indexPath.row]
        } else {
            if appSettings.showCompletedTasks {
                todo = todoList[indexPath.row]
            } else {
                todo = filteredTodos[indexPath.row]
            }
            
        }
        
        cell.set(todo: todo)
        return cell
    }
    
    
    // MARK: Table View - delegate ##################
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let vc = storyboard?.instantiateViewController(identifier: "showTodo") as? TodoShowViewController {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = appSettings.defaultDateFormat
           
                let todo:Todo
                if appSettings.grupedByCategory {
                    let category = categoryKeys[indexPath.section]
                    todo = groupedTodos[category]![indexPath.row]
                } else {
                    todo = todoList[indexPath.row]
                }
                print(todo)
                
                vc.showTitle = todo.title
                vc.showDescription = todo.description
                if todo.dueDate == nil {
                    vc.showDueDate = ""
                } else {
                    vc.showDueDate = dateFormatter.string(from:todo.dueDate!)
                }
                
                vc.showCreateAt = dateFormatter.string(from:todo.createAt)
                
                if todo.completedAt == nil {
                    vc.showCompleteAt = ""
                } else {
                    vc.showCompleteAt = dateFormatter.string(from:todo.completedAt!)
                }
                vc.isImportant = todo.isImportant
                vc.isComplete = todo.isComplete
                vc.category = todo.category
                self.navigationController?.pushViewController(vc, animated: true)
            }
     
        }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view, completionHandler in
            tableView.beginUpdates()
            
            if self.appSettings.grupedByCategory {
                let categoryKey = self.categoryKeys[indexPath.section]
                if var todos = self.groupedTodos[categoryKey] {
                    let todo = todos[indexPath.row]

                    if let todoListIndex = self.todoList.firstIndex(where: { $0.uid == todo.uid }) {
                        self.todoList[todoListIndex].isComplete = true
                        self.todoList[todoListIndex].completedAt = Date()
                    }
                    
                    if !self.appSettings.showCompletedTasks {
                        todos.remove(at: indexPath.row)
                        if todos.isEmpty {
                            self.groupedTodos.removeValue(forKey: categoryKey)
                            self.categoryKeys = self.groupedTodos.keys.sorted()
                            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                        } else {
                            self.groupedTodos[categoryKey] = todos
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            } else {
                self.todoList[indexPath.row].isComplete = true
                self.todoList[indexPath.row].completedAt = Date()
                if !self.appSettings.showCompletedTasks {
                    self.todoList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            saveTodoList(self.todoList)
            tableView.endUpdates()
            completionHandler(true)
        }
        NotificationCenter.default.post(name: NSNotification.Name("SettingsHaveChanged"), object: nil)
        action.backgroundColor = .systemGreen
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
                if todoListKey != nil {
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
