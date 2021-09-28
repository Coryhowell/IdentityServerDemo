//
//  ViewController.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    let loginViewModel = LoginViewModel()
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20 
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(loginButton)
        mainStackView.addArrangedSubview(logoutButton)
        
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        loginViewModel.login(presenter: self)
    }
    
    @objc func logoutButtonTapped() {
        loginViewModel.logout()
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

