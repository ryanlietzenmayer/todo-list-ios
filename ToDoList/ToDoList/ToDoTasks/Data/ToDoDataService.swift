//
//  ToDoDataService.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation

enum ToDoServiceError: Error {
    case networkFailure(HTTPError)
    case requestBuildFailure
    case invalidDataFailure
}

extension ToDoServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkFailure:
            return "Check your connection and try again."
        case .requestBuildFailure:
            return "Something went wrong. Try again in a moment."
        case .invalidDataFailure:
            return "Error with data returned."
        }
    }
}

protocol ToDoTasksFetching {
    // GET
    func getTasks() async throws(ToDoServiceError) -> [ToDoItem]
    // POST
    func createTask(_ item: ToDoItemData) async throws(ToDoServiceError) -> ToDoItem
    // PUT
    func putTask(_ item: ToDoItemData) async throws(ToDoServiceError) -> ToDoItem
    // DELETE
    func deleteTask(_ id: Int) async throws(ToDoServiceError)
}

struct ToDoDataService: ToDoTasksFetching {
    private let client: Networking
    
    // note: http://localhost:5041 didn't work
    private var baseURL: URL? {
        URL(string: "http://127.0.0.1:5041/")
    }

    init(client: Networking = HTTPClient()) {
        self.client = client
    }

    /// GET all tasks
    func getTasks() async throws(ToDoServiceError) -> [ToDoItem] {
        guard let baseURL else { throw .requestBuildFailure }

        let queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "completed", value: someBool),
//            URLQueryItem(name: "sortBy", value: "somevalue"),
        ]

        do {
            let request = try Request(method: .get, baseURL: baseURL, path: "tasks", queryItems: queryItems).make()
            let response: [ToDoItemData] = try await client.run(request: request)
            return response.compactMap { ToDoItem(from: $0) }
        } catch let error as HTTPError {
            throw .networkFailure(error)
        } catch {
            throw .requestBuildFailure
        }
    }
    
    /// GET single task
    func getTask(_ id: String) async throws(ToDoServiceError) -> ToDoItem? {
        return nil
    }
    
    /// POST task
    @discardableResult
    func createTask(_ item: ToDoItemData) async throws(ToDoServiceError) -> ToDoItem {
        guard let baseURL else { throw .requestBuildFailure }

        do {
            let request = try Request(method: .post, baseURL: baseURL, path: "tasks", body: item).make()
            let response: ToDoItemData = try await client.run(request: request)
            guard let item = ToDoItem(from: response) else {
                throw ToDoServiceError.invalidDataFailure
            }
            return item
        } catch {
            throw .networkFailure(error as! HTTPError)
        }
    }

    /// PUT update task
    func putTask(_ item: ToDoItemData) async throws(ToDoServiceError) -> ToDoItem {
        guard let baseURL, let itemId = item.id else { throw .requestBuildFailure }

        do {
            let request = try Request(method: .put, baseURL: baseURL, path: "tasks/\(itemId)", body: item).make()
            let response: ToDoItemData = try await client.run(request: request)
            guard let item = ToDoItem(from: response) else {
                throw ToDoServiceError.invalidDataFailure
            }
            return item
        } catch {
            throw .networkFailure(error as! HTTPError)
        }
    }

    /// DELETE task
    func deleteTask(_ id: Int) async throws(ToDoServiceError) {
        guard let baseURL else { throw .requestBuildFailure }

        do {
            let request = try Request(method: .delete, baseURL: baseURL, path: "tasks/\(id)").make()
            let _: Data = try await client.run(request: request)
        } catch {
            throw .networkFailure(error as! HTTPError)
        }
    }
}

extension ToDoDataService {
    public func createDefaultTasks() async throws(ToDoServiceError) {
        let task1 = ToDoItemData(id: nil, taskDescription: "task 1 ios", createdDate: nil, dueDate: Date.now.formatted(.iso8601), completed: false)
        let task2 = ToDoItemData(id: nil, taskDescription: "task 2 ios", createdDate: nil, dueDate: Date.distantFuture.formatted(.iso8601),  completed: true)
        let task3 = ToDoItemData(id: nil, taskDescription: "task 3 ios", createdDate: nil, dueDate: Date.distantPast.formatted(.iso8601),  completed: false)
        let tasks = [task1, task2, task3]
        for task in tasks {
            do {
                try await createTask(task)
            } catch {
                throw .requestBuildFailure
            }
        }
    }
}
