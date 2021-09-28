//
//  URLRequest+Request.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct RequestHeader {
    let field: String
    let value: String
}

extension URLRequest {
    init(url: URL, method: RequestMethod, headers: [RequestHeader], body: Data?) {
        self.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        self.httpMethod = method.rawValue
        headers.forEach({ self.addValue($0.value, forHTTPHeaderField: $0.field) })
        self.httpBody = body
    }
}
