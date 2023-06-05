//
//  File.swift
//  
//
//  Created by USER on 2023/06/06.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol GiphyNetworkService {
    func request<DTO: Decodable>(
        domain: String,
        path: String?,
        method: HTTPMethod,
        parameters: [String: String]?,
        headers: [String: String]?,
        body: [String: Any]?
    ) async throws -> DTO
}
