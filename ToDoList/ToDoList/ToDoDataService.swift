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

protocol TaskFetching {
    func tasks() async throws(ToDoServiceError) -> [ToDoItem]
}

struct ToDoDataService: TaskFetching {
    private let client: Networking

    private var searchLimit: Int {
        if ProcessInfo.processInfo.isLowPowerModeEnabled {
            return 25
        } else {
            return 50
        }
    }

    init(client: Networking = HTTPClient()) {
        self.client = client
    }

    func tasks() async throws(ToDoServiceError) -> [ToDoItem] {
        guard let baseURL = URL(string: "http://localhost:5041/") else {
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
