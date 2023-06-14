//
//  BaseIntercepter.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//
//

import Foundation
import Alamofire
import Combine

class BaseInterceptor: RequestInterceptor {
    
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
        
        // 헤더 부분 넣어주기
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        completion(.success(request))
    }
}
