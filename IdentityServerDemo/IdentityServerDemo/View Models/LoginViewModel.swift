//
//  LoginViewModel.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/28/21.
//

import Foundation
import AuthenticationServices

class LoginViewModel {
    
    var authProvider: AuthProvider = NetworkProvider.shared
    
    func login(presenter: ASWebAuthenticationPresentationContextProviding) {
        authProvider.createWebAuthSession(presenter: presenter) { error in
            if error == .canceledLogin {
                return
            }

        }?.start()
    }
    
    func logout() {
        authProvider.logoutUser()
    }
}
