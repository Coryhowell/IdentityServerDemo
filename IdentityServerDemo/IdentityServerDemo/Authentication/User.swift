//
//  User.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/30/21.
//

import Foundation

struct User: Codable {
    let sub: String?
    let email: String?
    let phoneNumber: String?
    let givenName: String?
    let familyName: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case sub = "sub"
        case email = "email"
        case phoneNumber = "phone_number"
        case givenName = "given_name"
        case familyName = "family_name"
        case name = "name"
    }
}
