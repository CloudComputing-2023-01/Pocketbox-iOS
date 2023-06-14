//
//  ApiClient.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//

import Foundation
import Alamofire

final class ApiClient {
    
    static let shared = ApiClient()
    
    static let BASE_URL = "http://pocketbox.shop/user/"
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor() // application/json
    ])
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    var session: Session
    
    init() {
        print("ApiClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
}

