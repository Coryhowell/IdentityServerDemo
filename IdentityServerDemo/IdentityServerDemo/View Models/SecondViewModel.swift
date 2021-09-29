//
//  SecondViewModel.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/28/21.
//

import Foundation

import AuthenticationServices

class SecondViewModel {
    
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
