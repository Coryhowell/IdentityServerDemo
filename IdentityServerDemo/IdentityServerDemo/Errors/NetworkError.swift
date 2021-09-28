//
//  NetworkError.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badRequest(Data?)
    case serverError
    case requestFailed
    case noResponse
    case badResponse
    case unauthorized
    case unknownError
    case noInternet
    
    var errorDescription: String? {
        switch self {
        case .noInternet: return NSLocalizedString("Please chek your internet connection", comment: "")
        default: return ""
        }
    }
}

extension NetworkError {
    init?(error: Error?) {
        guard let error = error else { return nil }
        switch error {
        case URLError.notConnectedToInternet: self = .noInternet
        default: self = .requestFailed
        }
    }
    
    init?(response: HTTPURLResponse?, data: Data? = nil) {
        guard let statusCode = response?.statusCode else {
            self = .noResponse
            return
        }
        switch statusCode {
        case 200...299: return nil
        case 300...399: self = .badResponse
        case 400, 402...499: self = .badRequest(data)
        case 500...599: self = .serverError
        default: self = .unknownError
        }
    }
}
