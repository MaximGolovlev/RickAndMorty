//
//  APIRequest.swift
//  RickAndMorty
//
//  Created by Максим on 08.07.2025.
//

import Foundation

protocol AnyAPIRequest {
    var httpType: HTTPType { get set }
    var url: URL { get }
    var urlRequest: URLRequest { get }
    var errorTitle: String { get set }
    var className: String { get set }
}

struct APIRequest: AnyAPIRequest {
    var httpType: HTTPType
    var host: String = HostName.current.string
    var path: String
    var query = [(String, String)]()
    var body = [String: Any?]()
    var headers: [APIHTTPHeader] = .jsonContentHeaders
    var errorTitle: String
    var className: String
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = query.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components.url!
    }
    
    var urlRequest: URLRequest {
        var r = URLRequest(url: url)
        r.httpMethod = httpType.rawValue
        r.cachePolicy = .reloadIgnoringCacheData
        if httpType != .GET { r.httpBody = try? JSONSerialization.data(withJSONObject: body) }
        headers.forEach({ r.addValue($0.value, forHTTPHeaderField: $0.name) })
        return r
    }
}

enum HostName: String {
    case development
    case production
    
    static var current: Self = .development

    var string: String {
        switch self {
        case .development:
            return "rickandmortyapi.com"
        case .production:
            return "rickandmortyapi.com"
        }
    }
}

extension Collection where Element: APIHTTPHeader {
    
    static var jsonContentHeaders: [APIHTTPHeader] {
        [
            APIHTTPHeader(name: "Content-Type", value: "application/json"),
            UserAgent.defaultAgent
        ]
    }
    
    static var tokenHeaders: [APIHTTPHeader] {
        [
            APIHTTPHeader(name: "Content-Type", value: "application/json"),
          //  APIHTTPHeader(name: "Authorization", value: "Token \(APIHTTPHeader.token)"),
            UserAgent.defaultAgent
        ]
    }
}

class APIHTTPHeader: Codable {
    
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

enum HTTPType: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

struct UserAgent: Codable {
    var name: String
    var value: String
    
    static var defaultAgent: APIHTTPHeader {
        var userAgent: String {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName)/\(versionString)"
                }()

                return "\(executable)/\(appVersion).\(appBuild) \(osNameVersion)"
            }
            
            return ""
        }
        
        return APIHTTPHeader(name: "User-Agent", value: userAgent)
    }
}
