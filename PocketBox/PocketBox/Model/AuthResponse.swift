//
//  AuthResponse.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct AuthResponse : Codable {
    var statusCode: Int
    var responseMessage: String
    
    var data: User
    enum CodingKeys: CodingKey {
        case statusCode
        case responseMessage
        case data
    }
}
