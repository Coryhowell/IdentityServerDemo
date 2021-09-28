//
//  Data+Decodable.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

extension Data {
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            (error as? DecodingError)?.record(decodable: type)
            print("Data Decoder Error: ", error.localizedDescription)
        }
        
        return nil
    }
}

extension Error where Self == DecodingError {
    func record<T: Decodable>(decodable: T.Type) {
        var description = ""
        var reason = ""
        
        switch self {
        case .dataCorrupted(let context):
            description = "data corrupted"
            reason = context.debugDescription
        case .keyNotFound(let key, let context):
            description = "key \(key) not found"
            reason = context.debugDescription
        case .typeMismatch(let type, let context):
            description = "type \(type) mismatch"
            reason = context.debugDescription
        case .valueNotFound(let value, let context):
            description = "value \(value) not found"
            reason = context.debugDescription
        default:
            description = "unknown"
            reason = "unknown"
        }
        
        print("Data Decoder Error: \(description)")
        print("Data Decoder Error: \(reason)")
    }
}
