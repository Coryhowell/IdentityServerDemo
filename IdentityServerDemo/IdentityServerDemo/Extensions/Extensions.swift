//
//  Extensions.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

extension Data {
    func base64URLEncodedString() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}

extension Bundle {
    static let identityServerURL: String = {
        guard let identityServerURL = Bundle.main.object(forInfoDictionaryKey: "IdentityServerURL") as? String else { return "https://demo.identityserver.io" }
        return identityServerURL
    }()
}
