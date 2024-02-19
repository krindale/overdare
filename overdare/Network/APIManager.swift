//
//  APIManager.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

final actor APIManager {
    
    static let shared: APIManager = .init()
    private init() {}
    
    func request(with request: URLRequest) async throws -> (Data, URLResponse) {
#if DEBUG
        print("\n--- Request Start ---")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        print("--- Request End ---\n")
#endif
        let (data, response) = try await URLSession.shared.data(for: request)
#if DEBUG
        if let httpResponse = response as? HTTPURLResponse {
            print("\n--- Response Start ---")
            print("Status Code: \(httpResponse.statusCode)")
            print("Response: \(data.prettyPrintedJSONString)")
            print("--- Response End ---\n")
        }
#endif
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
        switch statusCode {
        case 200..<300:
            break
        case 400..<500:
            let errorResponse = try? data.decode(GithubErrorResponse.self)
            throw NSError(domain: errorResponse?.message ?? "Network Error !!", code: statusCode)
        default:
            break
        }
        return (data, response)
    }
}
