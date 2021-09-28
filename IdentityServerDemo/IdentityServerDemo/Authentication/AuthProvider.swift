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
    func createWebAuthSession(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping (ClientError?) -> Void) -> ASWebAuthenticationSession?
    /// Clear session state and reset window to login
    func logoutUser()
}

extension NetworkProvider: AuthProvider {
    var isAuthorized: Bool {
        let isAuthorized = session?.accessToken != nil
        print("Authorized session: \(isAuthorized)")
        return isAuthorized
    }
      
    func createWebAuthSession(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping (ClientError?) -> Void) -> ASWebAuthenticationSession? {
        guard let authURL = AuthResource.authorization().urlComponents.url else { return nil }
        let authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: AuthResource.customScheme, completionHandler: self.exchangeCode(completion: { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            print("ID Token: \(self.session?.idToken as Any) \n  Access Token: \(self.session?.accessToken as Any) \n  Refresh Token: \(self.session?.refreshToken as Any)")
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
     
    func logoutUser() {
        saveSession()
        self.session?.idToken = nil
        self.session?.accessToken = nil
        self.session?.refreshToken = nil
        self.session?.isEphemeralSession = true
    }
}
