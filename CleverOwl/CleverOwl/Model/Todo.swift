//
//  Todo.swift
//  CleverOwl
//
//  Created by user228347 on 7/7/24.
//

import Foundation


struct Todo:Codable{
    var uid: String
    let title: String
    let description: String
    var category: Category
    var createAt: Date
    var completedAt: Date?
    var dueDate: Date?
    var isComplete: Bool
    var isImportant: Bool
    
    static func getSample() -> [Todo] {
        let today = Date()
        let plusOneHour = Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: today)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)!

        
        return [
            Todo(
                uid: UUID().uuidString,
                title: "Implement Authentication in iOS App! [next week]",
                description: "Use OAuth2 for secure authentication.",
                category: Category(name: "iOS", color: .orange, icon: "iphone"),
                createAt: today,
                completedAt: nil,
                dueDate: nextWeek,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Optimize Website for SEO [next month]",
                description: "Improve meta tags and content for better search engine ranking.",
                category: Category(name: "Web", color: .blue, icon: "desktopcomputer"),
                createAt: today,
                completedAt: nil,
                dueDate: nextMonth,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Conduct Usability Testing [today]",
                description: "Test the system with real users to gather feedback.",
                category: Category(name: "System Analysis", color: .red, icon: "doc.text"),
                createAt: today,
                completedAt: nil,
                dueDate: plusOneHour,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Create Icons for Mobile App! [next week]",
                description: "Design custom icons for the app's navigation menu.",
                category: Category(name: "UI/UX", color: .purple, icon: "pencil.and.outline"),
                createAt: today,
                completedAt: nil,
                dueDate: nextWeek,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Develop REST API for iOS App! [next week]",
                description: "Create a RESTful API to connect the iOS app with the backend.",
                category: Category(name: "iOS", color: .orange, icon: "iphone"),
                createAt: today,
                completedAt: nil,
                dueDate: nextWeek,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Refactor Web App Backend [next month]",
                description: "Improve code quality and performance of the web app's backend.",
                category: Category(name: "Web", color: .blue, icon: "desktopcomputer"),
                createAt: today,
                completedAt: nil,
                dueDate: tomorrow,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Prepare System Analysis Presentation! [+1h]",
                description: "Create slides to present the system analysis report findings.",
                category: Category(name: "System Analysis", color: .red, icon: "doc.text"),
                createAt: today,
                completedAt: nil,
                dueDate: plusOneHour,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Prototype New UI/UX Features! [+1h]",
                description: "Build prototypes for testing new user interface concepts.",
                category: Category(name: "UI/UX", color: .purple, icon: "pencil.and.outline"),
                createAt: today,
                completedAt: nil,
                dueDate: tomorrow,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Prototype New App [today]",
                description: "Build prototypes for testing new user interface concepts.",
                category: Category(name: "UI/UX", color: .purple, icon: "pencil.and.outline"),
                createAt: today,
                completedAt: nil,
                dueDate: today,
                isComplete: false,
                isImportant: false
            )
        ]
    }
}


let keyForTodoList = "Todo.CleverOwl"

func saveTodoList(_ todoLists: [Todo]) {
//    print("DEBUG: Todo - Save")
    do {
        let data = try JSONEncoder().encode(todoLists)
        UserDefaults.standard.set(data, forKey: keyForTodoList)
    } catch {
        print("Failed to encode todo list: \(error)")
    }
}

func loadTodoList() -> [Todo] {
//    print("DEBUG: Todo - load")
    guard let data = UserDefaults.standard.data(forKey: keyForTodoList) else {
        return Todo.getSample()
    }
    do {
        return try JSONDecoder().decode([Todo].self, from: data)
    } catch {
        return Todo.getSample()
    }
}
func deleteTodoList(){
//    print("DEBUG: Todo - Delete")
    UserDefaults.standard.removeObject(forKey: keyForTodoList)
}
