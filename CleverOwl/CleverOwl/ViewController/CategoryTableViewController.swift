//
//  CategoryTableViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var categoryList: [Category] = []
    var todoList:[Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "primary") ?? .blue]
        categoryList = loadCategory()
        todoList = loadTodoList()
//
//        print(categoryList)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(formAddCategory))
        self.navigationItem.rightBarButtonItem = addButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddCategory), name: NSNotification.Name("DidUpdateCategoryData"), object: nil)
    }
    
    @objc func handleAddCategory() {
        let row = (self.categoryList.count-1)
        print("Update Category \(row)")
        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: row, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .fade)
        tableView.endUpdates()
    }
    
    @objc func formAddCategory() {
        print("categoryForm")
        if let vc = self.storyboard?.instantiateViewController(identifier: "categoryForm") as? UIViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(categoryList.count)
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath) as! CategoryTableViewCell

        let category = categoryList[indexPath.row]
        
        cell.set(category: category)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if categoryList[indexPath.row].name == categoryDefaultValeu {
            let alert = UIAlertController(title: "This category cannot be removed.", message: "This category is used by the system to store uncategorized tasks.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let category = categoryList[indexPath.row]
        var countTasks: Int = 0
        if category != nil {
            countTasks = todoList.filter { $0.category.name == category.name }.count
        }
        
        if countTasks > 0 {
            let alert = UIAlertController(title: "There are tasks registered in this category.", message: "Remove all tasks from this category and then remove it.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        

        
        categoryList.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        saveCategory(categoryList)
        
    }

}
