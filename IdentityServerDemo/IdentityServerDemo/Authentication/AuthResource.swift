//
//  AuthResource.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation
import CryptoKit

struct AuthResource: NetworkResource {
    static let customScheme = "consumermobile"
    static let mobileClient = "interactive.confidential"
    static let clientSecret = "secret"
    static let redirectURI = "consumermobile://oauth2/callback"
    
    enum ResourceType: String {
        case authorize
        case token
        case userinfo
        case endsession
    }
    
    var type: ResourceType
    
    var queryItems: [URLQueryItem]?
    
    var method: RequestMethod
    
    var body: Data?
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Bundle.identityServerURL
        components.path = "/connect/" + type.rawValue
        components.queryItems = queryItems
        return components
    }
    
    init(type: ResourceType, queryItems: [URLQueryItem]? = nil, method: RequestMethod = .get, body: Data? = nil) {
        self.type = type
        self.queryItems = queryItems
        self.method = method
        self.body = body
    }
}

extension AuthResource {
    static let verifier: String = {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64URLEncodedString()
    }()
    
    static let challenge: String = {
        let data = Data(verifier.utf8)
        let buffer = SHA256.hash(data: data)
        let challenge = Data(buffer).base64URLEncodedString()
        return challenge
    }()
    
    static func authorization() -> AuthResource {
        return AuthResource(
            type: .authorize,
            queryItems: [
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "client_id", value: mobileClient),
                URLQueryItem(name: "scope", value: "openid profile email api offline_access"),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "code_challenge", value: challenge)
            ])
    }
    
    
    static func token(code: String) -> AuthResource {
        return AuthResource(
            type: .token,
            queryItems: [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "client_id", value: mobileClient),
                URLQueryItem(name: "client_secret", value: clientSecret),
                URLQueryItem(name: "code_verifier", value: verifier),
                URLQueryItem(name: "redirect_uri", value: redirectURI)
            ])
    }
    
    static func refresh(token: String) -> AuthResource {
        return AuthResource(
            type: .token,
            queryItems: [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "client_id", value: mobileClient),
                URLQueryItem(name: "client_secret", value: clientSecret),
                URLQueryItem(name: "refresh_token", value: token)
            ])
    }
        
    static func userInfo() -> AuthResource {
        return AuthResource(type: .userinfo)
    }
    
    static func endsession(idToken: String) -> AuthResource {
        return AuthResource(
            type: .endsession,
            queryItems: [
                URLQueryItem(name: "id_token_hint", value: idToken)
            ])
    }
}
