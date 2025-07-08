//
//  APIError.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL(String?)
    case invalidResponse(String?)
    case parsingError(String?)
    case customError(String?)
    
    var errorDescription: String? {
        var title: String?
        var message: String?
        switch self {
        case .invalidURL(let t):
            title = t
            message = "Error assembling valid URL"
        case .invalidResponse(let t):
            title = t
            message = "Invalid Response from the server"
        case .parsingError(let t):
            title = t
            message = "Unable to convert data to expected format"
        case .customError(let m):
            message = m
        }
        let text = [title, message].compactMap({ $0 }).joined(separator: ": ")
        return NSLocalizedString(text, comment: "")
    }
}
