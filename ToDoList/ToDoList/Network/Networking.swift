//
//  Networking.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation

enum HTTPError: Error {
    case invalidResponse
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unexpectedStatusCode(Int)
    case decodingError(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Networking {
    func run<Response: Decodable>(request: URLRequest) async throws -> Response
}
