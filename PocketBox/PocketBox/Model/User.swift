//
//  User.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct User: Codable {
    var name: String?
    var userId: Int?
    var email: String?
    
    var authorization: String?
    
    enum CodingKeys: CodingKey {
        case name
        case userId
        case email
        case authorization
    }
}


