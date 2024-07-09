//
//  SettingsTableViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var appSettings:AppSettings = AppSettings.defaultSettings()
    
    var settingsSections : [SettingsSection] = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "primary") ?? .blue]
        appSettings = loadAppSettings()
        loadSettings()
    }
    
    func loadSettings(){
        settingsSections.append(SettingsSection(title: "Presentation", options: [
            SettingsOption(
                title: "Grouped by category",
                icon: UIImage(systemName: "rectangle.3.group.fill"),
                iconBackgroundColor: UIColor(named: "primary"),
                isASwitch:true,
                isOn:self.appSettings.grupedByCategory,
                handler: {
                    self.appSettings.grupedByCategory = !self.appSettings.grupedByCategory
                    saveAppSettings(self.appSettings)
                    self.restartApp()
                }),
            SettingsOption(
                title: "Show completed tasks",
                icon: UIImage(systemName: "eye.slash.fill"),
                iconBackgroundColor: UIColor(named: "primary"),
                isASwitch:true,
                isOn:self.appSettings.showCompletedTasks,
                handler: {
                    self.appSettings.showCompletedTasks = !self.appSettings.showCompletedTasks
                    saveAppSettings(self.appSettings)
                    self.restartApp()
                })
        ]))
        
      
        settingsSections.append(SettingsSection(title: "Manage", options: [
            SettingsOption(title: "Categories", icon: UIImage(systemName: "tray.fill"), iconBackgroundColor: UIColor(named: "secondary"), handler: {
                if let vc = self.storyboard?.instantiateViewController(identifier: "categoryList") as? UITableViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                }),
        ]))
        
        
        settingsSections.append(SettingsSection(title: "System", options: [
            SettingsOption(title: "Clear data", icon: UIImage(systemName: "trash"), iconBackgroundColor: .red, handler: {
                    let alertController = UIAlertController(title: "This action will delete all saved data and restore the default data.", message: "This action will delete all saved data", preferredStyle: .alert)

                    let noAction = UIAlertAction(title: "Do not delete the data.", style: .default) { _ in
                        // Handle OK button tap
                    }
                    
                    let yesAction = UIAlertAction(title: "Yes, I want to delete the data", style: .destructive) { _ in
                        deleteTodoList()
                        deleteSettings()
                        self.restartApp()
                    }

                    alertController.addAction(noAction)
                    alertController.addAction(yesAction)

                    self.present(alertController, animated: true, completion: nil)
                }),
        ]))
    }
    
    func restartApp(){
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "rootView")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let option = settingsSections[indexPath.section].options[indexPath.row]
         
         guard let cell = tableView.dequeueReusableCell(
             withIdentifier: "settingsCell",
             for: indexPath
         ) as? SettingsTableViewCell else {
             return UITableViewCell()
         }
         cell.set(option: option)
         return cell
     }
     
    override func numberOfSections(in tableView: UITableView) -> Int {
         return settingsSections.count
     }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return settingsSections[section].options.count
     }
     
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         let section = settingsSections[section]
         return section.title
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = settingsSections[indexPath.section].options[indexPath.row]
        if !option.isASwitch {
            option.handler()
        }
    }
}
