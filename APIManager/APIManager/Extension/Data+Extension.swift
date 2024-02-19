//
//  Data+Extension.swift
//  APIManager
//
//  Created by Eddie on 2/19/24.
//

import Foundation

public extension Data {
    func decode<T: Decodable>(_ type: T.Type) throws -> (T?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(T.self, from: self)
        return response
    }
    
    var prettyPrintedJSONString: String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else {
            return String(data: self, encoding: .utf8) ?? "no data"
        }

        return prettyPrintedString
    }
}
