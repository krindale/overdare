//
//  APIManager.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

final public actor APIManager {
    
    static public let shared: APIManager = .init()
    private init() {}

    public func request(with request: URLRequest) async throws -> (Data, URLResponse) {
        let maxRetries = 3
        var currentRetry = 0

        while true {
            do {
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
                    return (data, response)
                case 400..<500:
                    let errorResponse = try? data.decode(GithubErrorResponse.self)
                    throw NSError(domain: errorResponse?.message ?? "Network Error !!", code: statusCode)
                default:
                    throw NSError(domain: "Unknown Network Error", code: statusCode)
                }
            } catch {
                currentRetry += 1
                if currentRetry >= maxRetries {
                    throw error
                }
                // Optionally, you can add delay here before retrying
            }
        }
    }
}
