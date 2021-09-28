//
//  NetworkResource.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

protocol NetworkResource {
    var queryItems: [URLQueryItem]? { get set }
    var method: RequestMethod { get set }
    var body: Data? { get set }
    var urlComponents: URLComponents { get }
    func authorizedRequest(session: IdentitySession) -> URLRequest?
}

extension NetworkResource {
    func urlEncodedRequest() -> URLRequest? {
        guard let data = urlComponents.query?.data(using: .utf8),
              let url = urlComponents.url else { return nil }
        return URLRequest(
            url: url,
            method: .post,
            headers: [
                RequestHeader(field: "Content-Type", value: "application/x-www-form-urlencoded")
            ],
            body: data)
    }
    
    func authorizedRequest(session: IdentitySession) -> URLRequest? {
        guard let url = urlComponents.url,
              let accessToken = session.accessToken else { return nil }
        
        return URLRequest(
            url: url,
            method: method,
            headers: [
                RequestHeader(field: "Authorization", value: "Bearer \(accessToken)")
            ],
            body: body)
    }
}
