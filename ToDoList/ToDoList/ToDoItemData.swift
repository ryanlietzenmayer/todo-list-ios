//
//  ToDoItemData.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation

public struct ToDoItemsData: Decodable {
    let items: [ToDoItemData]?
}

public struct ToDoItemData: Decodable {
    let id: Int?
    let taskDescription: String?
    let createdDate: Date?
    let dueDate: Date?
    let completed: Bool?
}

public struct ToDoItem: Identifiable {
    public let id: Int
    public let taskDescription: String
    public let createdDate: Date
    public let dueDate: Date?
    public let completed: Bool

    public init(id: Int, taskDescription: String, createdDate: Date, dueDate: Date?, completed: Bool) {
        self.id = id
        self.taskDescription = taskDescription
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.completed = completed
    }
}

extension ToDoItem {
    init?(from todoItemData: ToDoItemData) {
        guard let id = todoItemData.id, let taskDescription = todoItemData.taskDescription else { return nil }
        self.init(id: id,
                  taskDescription: taskDescription,
                  createdDate: todoItemData.createdDate ?? Date.now,
                  dueDate: todoItemData.dueDate,
                  completed: todoItemData.completed ?? false)
    }
}
