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
}

extension ToDoServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkFailure:
            return "Check your connection and try again."
        case .requestBuildFailure:
            return "Something went wrong. Try again in a moment."
        }
    }
}

protocol ToDoTasksFetching {
    // GET
    func getTasks() async throws(ToDoServiceError) -> [ToDoItem]
    // POST
    func createTask(_ item: ToDoItemData) async throws(ToDoServiceError) -> ToDoItem?
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
    func createTask(_ item: ToDoItemData) async throws(ToDoServiceError) -> ToDoItem? {
        guard let baseURL else { throw .requestBuildFailure }
        
        // Configure the request
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            // Encode the payload into JSON data
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(item)
            
            // Perform the network request using async/await
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Ensure the HTTP response is valid (200-299)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            // Decode the response
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ToDoItemData.self, from: data)
            return ToDoItem(from: decodedResponse)
        } catch {
            throw .requestBuildFailure
        }
    }

    /// PUT update task
    func putTask(_ id: String) async throws(ToDoServiceError) -> ToDoItem? {
        return nil
    }

    /// DELETE task
    func deleteTask(_ id: String) async throws(ToDoServiceError) {
    }

}

extension ToDoDataService {
    public func createDefaultTasks() {
        let task1 = ToDoItemData(id: 1, taskDescription: "task 1", completed: false)
        let task2 = ToDoItemData(id: 2, taskDescription: "task 2", completed: true)
        let task3 = ToDoItemData(id: 3, taskDescription: "task 3", completed: false)
    }
}
