//
//  URLRequest+Extension.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

extension URLRequest {
    static public func create<T: APIProtocol>(from api: T) throws -> URLRequest {
        var components = URLComponents(url: api.baseURL.appendingPathComponent(api.path), resolvingAgainstBaseURL: false)
        components?.queryItems = api.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components?.url else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url, timeoutInterval: 30.0)
        request.httpMethod = api.method
        request.allHTTPHeaderFields = api.header
        
        return request
    }
}
