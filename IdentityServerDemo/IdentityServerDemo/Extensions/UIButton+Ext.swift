//
//  UIButton+Ext.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/29/21.
//

import Foundation
import UIKit


extension UIButton {
    
    class func login() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        if #available(iOS 15.0, *) {
            button.configuration = .filled()
        } else {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .body)
            button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 20, bottom: 7, right: 20)
            button.layer.cornerRadius = 5
        }
        return button
        
    }
    
    class func logout() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        if #available(iOS 15.0, *) {
            button.configuration = .tinted()
        } else {
            button.backgroundColor = #colorLiteral(red: 0.8215045333, green: 0.9039879441, blue: 1, alpha: 1)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .body)
            button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 20, bottom: 7, right: 20)
            button.layer.cornerRadius = 5
        }
        return button
    }
    
    class func defaultStyle(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        return button
    }
}
