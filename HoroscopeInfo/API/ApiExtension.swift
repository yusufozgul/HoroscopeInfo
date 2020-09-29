//
//  ApiExtension.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

/// Deezer Api constant data
struct Constant {
    static let baseUrl = "https://json.astrologyapi.com/v1/"
    static let apiAuth = "Basic NjE0MzQzOjhmYWQwYmEyZGU4YmNjMDFlNzk1YmI0YjRiZWQ2ODgz"
}

/// Custom Api Error Type include network, decoding or url encode error
enum ApiError: Error {
    case network(errorMessage: String)
    case decoding(errorMessage: String)
    case urlEncode
    
    var localizedDescription: String {
        switch self {
        case .network(let message):
            return message
        case .decoding(let message):
            return message
        case .urlEncode:
            return "Url encode error"
        }
    }
}

enum HttpMethod: String {
    case GET
    case POST
}

extension Encodable {
    func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
}

/// Generic  Api error response type
struct ApiResponseError: Decodable {
    let status: Bool
    let msg: String
}
