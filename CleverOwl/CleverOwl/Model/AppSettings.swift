//
//  AppSettings.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import Foundation
import UIKit

struct SettingsOption {
    var title:String
    var icon:UIImage? = nil
    var iconBackgroundColor: UIColor? = nil
    var isASwitch: Bool = false
    var isOn: Bool = false
    var handler: (()->Void)
}


struct SettingsSection{
    let title:String
    let options: [SettingsOption]
}


struct AppSettings: Codable{
    var grupedByCategory:Bool
    var showCompletedTasks:Bool
    var sortByDueDate:Bool
    var importantFirst:Bool
    var defaultDateFormat:String
    
    static func defaultSettings() -> AppSettings {
        return AppSettings(grupedByCategory: true,
                           showCompletedTasks: false,
                           sortByDueDate: true,
                           importantFirst: true,
                           defaultDateFormat: "E, d MMM yyyy HH:mm")
    }
}


let keyForAppSetings = "AppSettings.CleverOwl"

func saveAppSettings(_ appSettings:AppSettings){
//    print("DEBUG: AppSettings - Save")
    let data = try? JSONEncoder().encode(appSettings)
    UserDefaults.standard.set(data, forKey: keyForAppSetings)
}

func loadAppSettings() -> AppSettings {
//    print("DEBUG: AppSettings - Load")
    guard let data = UserDefaults.standard.data(forKey: keyForAppSetings) else {
        return AppSettings.defaultSettings()
    }
    do{
        return try JSONDecoder().decode(AppSettings.self, from: data)
    }catch {
        return AppSettings.defaultSettings()
    }
}

func deleteSettings(){
//    print("DEBUG: AppSettings - Delete")
    UserDefaults.standard.removeObject(forKey: keyForAppSetings)
}
