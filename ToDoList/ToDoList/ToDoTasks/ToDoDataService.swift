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
    func tasks() async throws(ToDoServiceError) -> [ToDoItem]
}

struct ToDoDataService: ToDoTasksFetching {
    private let client: Networking

    init(client: Networking = HTTPClient()) {
        self.client = client
    }

    func tasks() async throws(ToDoServiceError) -> [ToDoItem] {
        // note: http://localhost:5041 didn't work
        guard let baseURL = URL(string: "http://127.0.0.1:5041/") else {
            throw .requestBuildFailure
        }

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
}
