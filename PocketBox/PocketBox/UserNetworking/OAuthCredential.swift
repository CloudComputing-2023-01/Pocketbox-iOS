//
//  OAuthCredential.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//

import Foundation
import Alamofire

struct OAuthCredential : AuthenticationCredential {
    var requiresRefresh: Bool
    let accessToken: String
    
}
