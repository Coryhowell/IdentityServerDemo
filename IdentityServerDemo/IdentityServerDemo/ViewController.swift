//
//  ViewController.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import UIKit

class ViewController: UIViewController {
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = .white
        view.addSubview(loginButton)
        
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }


}

