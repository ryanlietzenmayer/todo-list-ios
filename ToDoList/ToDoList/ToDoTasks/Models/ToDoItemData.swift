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
    init(from todoItem: ToDoItem, isCreate: Bool = false) {        
        self.init(id: isCreate ? nil : todoItem.id,
                  taskDescription: todoItem.taskDescription,
                  createdDate: todoItem.createdDate.formatted(.iso8601),
                  dueDate: todoItem.dueDate.formatted(.iso8601),
                  completed: todoItem.completed)
    }
}
