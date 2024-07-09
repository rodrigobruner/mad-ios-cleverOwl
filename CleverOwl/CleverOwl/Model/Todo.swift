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
                title: "Complete the project documentation",
                description: "Ensure all modules are properly documented.",
                category: Category(name: "Work", color: .blue, icon:"case"),
                createAt: today,
                completedAt: nil,
                dueDate: nextWeek,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Meeting",
                description: "",
                category: Category(name: "Work", color: .blue, icon:"case"),
                createAt: today,
                completedAt: nil,
                dueDate: tomorrow,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Schedule dentist appointment",
                description: "Call Dr. Smith's office to schedule cleaning.",
                category: Category(name: "Health", color: .red, icon:"cross.case"),
                createAt: today,
                completedAt: nil,
                dueDate: nextMonth,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Book flight tickets",
                description: "Look for the best deals to visit family.",
                category: Category(name: "Travel", color: .orange,icon:"airplane"),
                createAt: today,
                completedAt: nil,
                dueDate: nil,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Learn SwiftUI",
                description: "Complete the SwiftUI tutorial on Ray Wenderlich.",
                category: Category(name: "Education", color: .purple, icon:"book"),
                createAt: today,
                completedAt: nil,
                dueDate: nil,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Organize anotations",
                description: "",
                category: Category(name: "Education", color: .purple, icon:"book"),
                createAt: today,
                completedAt: nil,
                dueDate: plusOneHour,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Prepare for the marathon",
                description: "Increase weekly mileage and focus on nutrition.",
                category: Category(name: "Health", color: .red, icon:"cross.case"),
                createAt: today,
                completedAt: nil,
                dueDate: nextMonth,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Plan weekend hike",
                description: "Check weather and trail conditions.",
                category: Category(name: "Health", color: .red, icon:"cross.case"),
                createAt: today,
                completedAt: nil,
                dueDate: tomorrow,
                isComplete: false,
                isImportant: false
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Update resume",
                description: "Add recent projects and skills.",
                category: Category(name: "Personal", color: .green, icon:"person"),
                createAt: today,
                completedAt: nil,
                dueDate: nextWeek,
                isComplete: false,
                isImportant: true
            ),
            Todo(
                uid: UUID().uuidString,
                title: "Read 'Atomic Habits'",
                description: "Finish reading and take notes.",
                category: Category(name: "Education", color: .purple, icon:"book"),
                createAt: today,
                completedAt: nil,
                dueDate: nextMonth,
                isComplete: false,
                isImportant: false
            )
        ]
    }
}


let keyForTodoList = "Todo.CleverOwl"

func saveTodoList(_ todoLists: [Todo]) {
    print("DEBUG: Todo - Save")
    do {
        let data = try JSONEncoder().encode(todoLists)
        UserDefaults.standard.set(data, forKey: keyForTodoList)
    } catch {
        print("Failed to encode todo list: \(error)")
    }
}

func loadTodoList() -> [Todo] {
    print("DEBUG: Todo - load")
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
    print("DEBUG: Todo - Delete")
    UserDefaults.standard.removeObject(forKey: keyForTodoList)
}
