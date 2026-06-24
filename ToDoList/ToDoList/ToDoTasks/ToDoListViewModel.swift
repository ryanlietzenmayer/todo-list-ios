//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation
import AVFoundation
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
                item = try await service.putTask(ToDoItemData(from:item))
            } catch {
                
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

@MainActor
@Observable
final class ToDoListViewModel {
    
    var items: [ToDoItem] = []
    
    private let service: ToDoTasksFetching
    private var getItemsTask: Task<Void, Never>?
    
    convenience init() {
        self.init(service: ToDoDataService())
    }
    
    /// used by #Preview
    convenience init(items: [ToDoItem]) {
        self.init(service: ToDoDataService(), isPreview: true)
        self.items = items
    }
    
    init(service: ToDoTasksFetching, isPreview: Bool = false) {
        self.service = service
        if !isPreview {
            getAllToDoItems()
        }
    }
    
    func getAllToDoItems() {
        getItemsTask?.cancel()
        
        getItemsTask = Task { @MainActor in
            do {
                guard !Task.isCancelled else { return }
                
                items = []
                
                let items = try await service.getTasks()
                guard !Task.isCancelled else { return }
                self.items = items
            } catch {
                guard !Task.isCancelled else { return }
                self.items = []
            }
        }
    }
    
    func create(_ item: ToDoItem) {
        Task { @MainActor in
            do {
                let createdItem = try await service.createTask(ToDoItemData(from: item))
                self.items.append(createdItem)
            } catch {
                
            }
        }
    }
    
    func update(_ item: ToDoItem) {
        Task { @MainActor in
            do {
                let updatedItem = try await service.putTask(ToDoItemData(from: item))
                self.items.append(updatedItem)
            } catch {
                // TODO: catch
            }
        }
    }
}
