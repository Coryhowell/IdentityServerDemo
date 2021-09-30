//
//  NetworkProvider.swift
//  IdentityServerDemo
//
//  Created by Cory Howell on 9/27/21.
//

import Foundation

class NetworkProvider {
    
    typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    static let shared = NetworkProvider()
    
    let queue = DispatchQueue(label: "NetworkProvider", qos: .userInteractive)
        
    let urlSession: URLSession
    
    var session: IdentitySession?
        
    static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10
        configuration.waitsForConnectivity = false
        return configuration
    }()
    
    init(urlSession: URLSession = URLSession(configuration: NetworkProvider.configuration)) {
        self.urlSession = urlSession
        // use Keychain / Core Data to save and load session
    }
    
    // load session from keychain
    
    
    
    func saveSession() {
        // save session to keychain
    }
    
    /// Build and make authorized URLSession dataTask request for NetworkResource.
    func request(resource: NetworkResource, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        queue.async {
            var anyError: ClientError?
            
            // Start token refresh step
            self.refreshSession { error in
                anyError = error
            }
            
            // Try and unwrap authorized request
            guard anyError == nil,
                let session = self.session,
                let request = resource.authorizedRequest(session: session) else {
                    
                    DispatchQueue.main.async {
                        self.logoutUser()
                    }
                    completion(.failure(.unauthorized))
                    return
            }
            // Complete authorized request
            self.makeRequest(request: request, completion: completion)
        }
    }
    
    
    func makeRequest(request: URLRequest, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        // Use semaphore to block thread until request has completed
        let semaphore = DispatchSemaphore(value: 0)
        let task = self.urlSession.dataTask(with: request, completionHandler: self.validate(completion: { result in
            defer {
                semaphore.signal()
            }
            do {
                let data = try result.get()
                completion(.success(data))
            }
            catch NetworkError.unauthorized {
                DispatchQueue.main.async {
                    self.logoutUser()
                }
                completion(.failure(.unauthorized))
            }
            catch {
                completion(.failure(error as! NetworkError))
            }
        }))
        task.resume()
        semaphore.wait()
    }
    
    /// Validate URLSessionDataTask response before returning to original caller.
    func validate(completion: @escaping (Result<Data?, NetworkError>) -> Void) -> DataTaskCompletionHandler {
        return { data, response, error in
            if let networkError = NetworkError(error: error) {
                if networkError == .noInternet {
                    DispatchQueue.main.async {
                        // Show no internet error.
                    }
                }
                completion(.failure(networkError))
                return
            }
            
            if let networkError = NetworkError(response: response as? HTTPURLResponse, data: data) {
                completion(.failure(networkError))
                return
            }
            
            completion(.success(data))
        }
    }
    
    /// Create user session.
    func createSession(request: URLRequest, completion: @escaping ((ClientError?) -> Void)) {
        makeRequest(request: request) { [weak self] result in
            self?.session = try? result.get()?.decode(IdentitySession.self)
            self?.session?.setExpirationDate()
            completion(self?.session == nil ?  .createSessionFailed : nil )
        }
    }
    
    /// Refresh user session unless valid access token is available
    func refreshSession(completion: @escaping (ClientError?) -> Void) {
        guard let session = session else {
            completion(.sessionInvalid)
            return
        }
        
        // Access token still good, just return
        if session.accessToken != nil && !session.hasExpired {
            print("Returning valid access token")
            completion(nil)
            return
        }
        
        guard let token = session.refreshToken,
              let request = AuthResource.refresh(token: token).urlEncodedRequest() else {
            completion(.refreshFailed)
            return
        }
        
        print("refreshing session")
        createSession(request: request, completion: completion)
    }
    
}
