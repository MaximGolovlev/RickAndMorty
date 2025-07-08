//
//  APIManager.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import Foundation

class APIManager: NSObject {
    
    static var shared = APIManager()
    
    private override init() { }
    
    func makeRequest<T: Codable>(request: AnyAPIRequest,
                                 retryCount: Int = 0) async throws -> T {
        
        do {
            let data = try await getData(request: request)
            let item = try JSONDecoder().decode(T.self, from: data)
            return item
        } catch {
            if retryCount != 0 {
                return try await makeRequest(request: request, retryCount: retryCount - 1)
            } else {
                throw error
            }
        }
    }
    
    func makeRequest(request: AnyAPIRequest,
                     retryCount: Int = 0) async throws -> [String: Any] {
        
        do {
            let data = try await getData(request: request)
            if let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return dict
            } else {
                throw NetworkError.parsingError(request.errorTitle)
            }
        } catch {
            if retryCount != 0 {
                return try await makeRequest(request: request, retryCount: retryCount - 1)
            } else {
                throw error
            }
        }
    }
}

extension APIManager {
    
    private func getData(request: AnyAPIRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: request.urlRequest, delegate: self)
        return data
    }
    
}

extension APIManager: URLSessionTaskDelegate {
    func urlSession(_: URLSession,
                    task _: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                                     nil)
        }
        
        return completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                                 URLCredential(trust: serverTrust))
    }
}

