//
//  UserInfoResponse.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct UserInfoResponse: Codable {
    let user: UserData
    enum CodingKeys: CodingKey {
        case user
    }
}
