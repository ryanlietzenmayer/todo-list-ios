//
//  Request.swift
//  ToDoList
//
//  Created by Meng Wang on 6/5/26.
//

import Foundation

struct Request {
    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Encodable?
    let encoder: JSONEncoder
    let cachePolicy: URLRequest.CachePolicy

    init(
        method: HTTPMethod,
        baseURL: URL,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Encodable? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.encoder = encoder
        self.cachePolicy = cachePolicy
    }

    func make() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = cachePolicy
        request.allHTTPHeaderFields = headers

        if let body {
            let encodedBody = try encoder.encode(body)
            request.httpBody = encodedBody

            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        }

        return request
    }
}
