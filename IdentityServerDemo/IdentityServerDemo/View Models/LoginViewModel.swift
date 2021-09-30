//
//  LoginViewModel.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/28/21.
//

import Foundation
import AuthenticationServices

protocol LoginViewModelDelegate: AnyObject {
    func didCreateUser(_ user: User)
    func didReceiveErrorMessage(_ message: String)
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    var authProvider: AuthProvider = NetworkProvider.shared
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
        
    func login(presenter: ASWebAuthenticationPresentationContextProviding) {
        authProvider.createWebAuthSession(presenter: presenter) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if let user = user {
                        self?.delegate?.didCreateUser(user)
                    }
                case .failure(let error):
                    if error != .canceledLogin {
                        self?.delegate?.didReceiveErrorMessage(error.localizedDescription)
                    }
                }
            }
        }?.start()
    }
    
    func logout() {
        authProvider.logoutUser()
    }
}
