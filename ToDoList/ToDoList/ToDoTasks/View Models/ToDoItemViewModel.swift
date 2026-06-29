//
//  ToDoItemViewModel.swift
//  ToDoList
//
//  Created by Meng Wang on 6/24/26.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class ToDoItemViewModel {
    var item: ToDoItem
    
    private let service: ToDoTasksFetching
    
    init(item: ToDoItem) {
        self.item = item
        self.service = ToDoDataService()
    }
    
    func toggleCompleted() {
        Task { @MainActor in
            do {
                item.completed = !item.completed
                item = try await service.putTask(ToDoItemData(from: item))
            } catch {
                
            }
        }
    }
    
    func editCompleted(_ editedItem: ToDoItem) {
        Task { @MainActor in
            do {
                item = try await service.putTask(ToDoItemData(from: editedItem))
            } catch {
                print("error on edit")
            }
        }
    }
    
    func delete() {
        Task { @MainActor in
            do {
                try await service.deleteTask(item.id)
            } catch {
                
            }
        }
    }
}
