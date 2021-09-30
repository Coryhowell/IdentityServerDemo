//
//  ClientError.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

enum ClientError: LocalizedError {
    case canceledLogin
    case codeExchangeFailed
    case noUser
    case unauthorized
    case createSessionFailed
    case sessionInvalid
    case refreshFailed
    
    var errorDescription: String? {
        switch self {
        case .noUser: return NSLocalizedString("We failed to fetch your user information", comment: "")
        default: return NSLocalizedString("We failed to log you in", comment: "")
        }
    }
}
