//
//  AuthProvider.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation
import AuthenticationServices

protocol AuthProvider {
    /// User must have a vaild access token
    var isAuthorized: Bool { get }
    /// Create web auth session and handle code exchange
    func createWebAuthSession(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping (Result<User?, ClientError>) -> Void) -> ASWebAuthenticationSession?
    /// Get IDP user info
    func fetchUser(completion: @escaping (Result<User?, ClientError>) -> Void)
    /// Clear session state and reset window to login
    func logoutUser()
}

extension NetworkProvider: AuthProvider {
    var isAuthorized: Bool {
        let isAuthorized = session?.accessToken != nil
        print("Authorized session: \(isAuthorized)")
        return isAuthorized
    }
          
    func createWebAuthSession(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping (Result<User?, ClientError>) -> Void) -> ASWebAuthenticationSession? {
        guard let authURL = AuthResource.authorization().urlComponents.url else { return nil }
        let authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: AuthResource.customScheme, completionHandler: self.exchangeCode(completion: { [weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self?.fetchUser(completion: completion)
        }))
        authSession.presentationContextProvider = presenter
        if let isEphemeralSession = session?.isEphemeralSession {
            authSession.prefersEphemeralWebBrowserSession = isEphemeralSession
        }
        return authSession
    }
    
    func exchangeCode(completion: @escaping (ClientError?) -> Void) -> (URL?, Error?) -> Void {
        return { [weak self] url, error in
            if let error = error as? ASWebAuthenticationSessionError,
               error.code == .canceledLogin {
                completion(.canceledLogin)
                return
            }
            
            /// Parse Authorization Code
            guard let url = url,
                let queryItems = URLComponents(string: url.absoluteString)?.queryItems,
                let code = queryItems.filter({ $0.name == "code" }).first?.value,
                let request = AuthResource.token(code: code).urlEncodedRequest() else {
                completion(.codeExchangeFailed)
                return
            }
            print("Received code: ", code)
            print("Creating Session")
            self?.createSession(request: request, completion: completion)
        }
    }
    
    func fetchUser(completion: @escaping (Result<User?, ClientError>) -> Void) {
        request(resource: AuthResource.userInfo()) { result in
            guard let userInfo = try? result.get()?.decode(User.self) else {
                completion(.failure(.noUser))
                return
            }
            
            let newUser = User(
                sub: userInfo.sub,
                email: userInfo.email,
                phoneNumber: userInfo.phoneNumber,
                givenName: userInfo.givenName,
                familyName: userInfo.familyName,
                name: userInfo.name)
            completion(.success(newUser))
        }
    }
     
    func logoutUser() {
        saveSession()
        self.session?.idToken = nil
        self.session?.accessToken = nil
        self.session?.refreshToken = nil
        self.session?.isEphemeralSession = true
    }
}
