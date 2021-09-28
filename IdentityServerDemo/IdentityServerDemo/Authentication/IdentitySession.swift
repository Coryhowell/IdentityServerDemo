//
//  IdentitySession.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

struct IdentitySession: Codable, Equatable {
    var idToken: String?
    var accessToken: String?
    var expiresIn: Int?
    var refreshToken: String?
    var tokenType: String?
    var scope: String?
    
    /// Set ephemeral session to "reset" cookies
    var isEphemeralSession = false
    
    /// Date generated from expiresIn
    var expirationDate: Date!
    
    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case scope = "scope"
        case expirationDate = "expirationDate"
    }
}

extension IdentitySession {
    /// Validates expiration date
    var hasExpired: Bool {
        guard let expirationDate = self.expirationDate else { return true }
        let now = Date()
        return now >= expirationDate
    }

    /// The subscriber ID parsed from the access token
    var subscriberId: String? {
        return accessToken?.getIdTokenClaims()?.decode(WebToken.self)?.sub
    }
    
    mutating func setExpirationDate() {
        guard let expiresIn = self.expiresIn else { return }
        expirationDate = Date().addingTimeInterval(Double(expiresIn))
    }
}

extension String {
    func getIdTokenClaims() -> Data? {
        /// Decoding ID token claims.
        let jwtParts = self.split(separator: ".")
        guard jwtParts.count > 1 else { return nil }
        let claimsPart = String(jwtParts[1])
        return Data(base64Encoded: claimsPart.padBase64Encoded())
    }
    
    /**
            Completes base64Encoded string to multiple of 4 to allow for decoding with NSdata.
     */
    func padBase64Encoded() -> String {
        let remainder = self.count % 4
        if remainder > 0 {
            return self.padding(toLength: self.count + 4 - remainder, withPad: "=", startingAt: 0)
        }
        return self
    }
}

struct WebToken: Codable {
    let sub: String
}
