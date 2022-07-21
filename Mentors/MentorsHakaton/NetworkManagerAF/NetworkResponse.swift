//
//  Urls.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 09.07.2022.
//

import Foundation

enum APINetworkError: Error {
    case dataNotFound
    case httpRequestFailed
    case dontHaveRights(String)
}


//struct Response: Codable {
//    let id: String
//    let username: String
//    let token: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case username
//        case token
//    }
//}

extension APINetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "Error: Did not receive data"
        case .httpRequestFailed:
            return "Error: HTTP request failed"
        case .dontHaveRights:
            return "Error: You don't have rights"
        }
    }
}
