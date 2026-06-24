//
//  ToDoItemData.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation

public struct ToDoItemData: Encodable, Decodable {
    let id: Int?
    let taskDescription: String?
    let createdDate: String?
    let dueDate: String?
    let completed: Bool?
}

extension ToDoItemData {
    init(from todoItem: ToDoItem) {
        var dueDateString: String? = nil
        if let dueDate = todoItem.dueDate {
            dueDateString = dueDate.formatted(.iso8601)
        }
        
        self.init(id: todoItem.id,
                  taskDescription: todoItem.taskDescription,
                  createdDate: todoItem.createdDate.formatted(.iso8601),
                  dueDate: dueDateString,
                  completed: todoItem.completed)
    }
}
