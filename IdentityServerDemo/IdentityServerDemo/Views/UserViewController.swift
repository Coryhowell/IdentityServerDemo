//
//  UserViewController.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/29/21.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    
    var user: User?
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "User #: "
        label.numberOfLines = 0
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name: "
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: "
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInfo(user)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(subLabel)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(emailLabel)
        
        mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    
    func setUserInfo(_ user: User?) {
        if let user = user {
            subLabel.text = "User Subscriber #: \(user.sub!)"
            nameLabel.text = "Name: \(user.name!)"
            emailLabel.text = "Email: \(user.email!)"
        }
    }
}
