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
final class ToDoListViewModel {

    var items: [ToDoItem] = []

    private let service: ToDoTasksFetching
    private var getItemsTask: Task<Void, Never>?

    convenience init() {
        self.init(service: ToDoDataService())
    }

    init(service: ToDoTasksFetching) {
        self.service = service
        getAllToDoItems()
    }

    func getAllToDoItems() {
        getItemsTask?.cancel()

        getItemsTask = Task { @MainActor in
            do {
                guard !Task.isCancelled else { return }

                items = []

                let items = try await service.tasks()
                guard !Task.isCancelled else { return }
                self.items = items
            } catch let error as ToDoServiceError {
                guard !Task.isCancelled else { return }
                self.items = []
            } catch {
                guard !Task.isCancelled else { return }
                self.items = []
            }
        }
    }
}
