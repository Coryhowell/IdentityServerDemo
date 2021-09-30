//
//  SecondViewController.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/28/21.
//

import UIKit
import AuthenticationServices


class SecondViewController: UIViewController {
    
    var viewModel: SecondViewModel!
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Login From Somewhere Else"
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SecondViewModel(delegate: self)
        
        view.backgroundColor = .white
        
        let loginButton = UIButton.login()
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mainLabel)
        mainStackView.addArrangedSubview(loginButton)
        
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        viewModel.login(presenter: self)
    }
    
    func presentUserView(user: User) {
        let userViewController = UserViewController(user: user)
        present(userViewController, animated: true, completion: nil)
    }
}

extension SecondViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window! 
    }
}

extension SecondViewController: LoginViewModelDelegate {
    func didCreateUser(_ user: User) {
        presentUserView(user: user)
    }
    
    func didReceiveErrorMessage(_ message: String) {
        print(message)
    }
}
