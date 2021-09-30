//
//  ViewController.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    var loginViewModel: LoginViewModel!
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Main Login View"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel = LoginViewModel(delegate: self)
        
        let loginButton = UIButton.login()
        let logoutButton = UIButton.logout()
        let openViewButton = UIButton.defaultStyle(title: "Open View")
 
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mainLabel)
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(logoutButton)
        mainStackView.addArrangedSubview(openViewButton)
        
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        openViewButton.addTarget(self, action: #selector(otherButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        loginViewModel.login(presenter: self)
    }
    
    @objc func logoutButtonTapped() {
        loginViewModel.logout()
    }
    
    @objc func otherButtonTapped() {
        let secondVC = SecondViewController()
        self.present(secondVC, animated: true, completion: nil)
    }
    
    func presentUserView(user: User) {
        let userViewController = UserViewController(user: user)
        present(userViewController, animated: true, completion: nil)
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}


extension ViewController: LoginViewModelDelegate {
    func didCreateUser(_ user: User) {
        presentUserView(user: user)
    }
    
    func didReceiveErrorMessage(_ message: String) {
        print(message)
    }
    
    
}
