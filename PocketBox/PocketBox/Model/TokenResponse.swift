//
//  TokenResponse.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct TokenResponse: Codable {
    let message: String
    let token: TokenData
}
