//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Meng Wang on 6/24/26.
//

import Foundation

public struct ToDoItem: Identifiable, Hashable {
    public let id: Int
    public var taskDescription: String
    public let createdDate: Date
    public var dueDate: Date
    public var completed: Bool = false
    
    public var createdDateString: String {
        "Created: " + dateString(createdDate)
    }
    public var dueDateString: String {
        "Due: " + dateString(dueDate)
    }

    public init(id: Int, taskDescription: String, createdDate: Date, dueDate: Date, completed: Bool) {
        self.id = id
        self.taskDescription = taskDescription
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.completed = completed
    }
}

extension ToDoItem {
    
    /// New task
    init(taskDescription: String, dueDate: Date = Date.now) {
        self.id = -1
        self.taskDescription = taskDescription
        self.createdDate = Date.now
        self.dueDate = dueDate
    }
    
    init?(from todoItemData: ToDoItemData) {
        guard let id = todoItemData.id, let taskDescription = todoItemData.taskDescription else { return nil }
                
        let isoFormatter = ISO8601DateFormatter()
        let createdDate = isoFormatter.date(from: todoItemData.createdDate ?? "")
        let dueDate = isoFormatter.date(from: todoItemData.dueDate ?? "")

        self.init(id: id,
                  taskDescription: taskDescription,
                  createdDate: createdDate ?? Date.now,
                  dueDate: dueDate ?? Date.distantFuture,
                  completed: todoItemData.completed ?? false)
    }
}

func dateString(_ date: Date?) -> String {
    
    guard let date else { return "Undefined" }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    // US English Locale (en_US)
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter.string(from: date) // Jan 2, 2001
}
