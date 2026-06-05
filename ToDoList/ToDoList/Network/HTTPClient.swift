//
//  HTTPClient.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation

struct HTTPClient: Networking {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func run<Response: Decodable>(request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(Response.self, from: data)
            } catch {
                throw HTTPError.decodingError(error)
            }
        case 400...499:
            throw HTTPError.clientError(statusCode: http.statusCode)
        case 500...599:
            throw HTTPError.serverError(statusCode: http.statusCode)
        default:
            throw HTTPError.unexpectedStatusCode(http.statusCode)
        }
    }
}
