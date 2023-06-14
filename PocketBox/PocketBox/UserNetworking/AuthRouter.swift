//
//  AuthRouter.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입, 로그인, 토큰갱신
enum AuthRouter: URLRequestConvertible {
    
    case register(name: String, email: String, password: String)
    case login(email: String, password: String)
    case userInfo(name: String?, password: String?)
    case tokenRefresh
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register:
            return "register"
        case .login:
            return "sign-up"
        case .userInfo:
            return "info"
        case .tokenRefresh:
            return "user/token-refresh"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .post
        }
    }
    
    var parameters: Parameters{
        switch self {
        case let .login(email, password):
            var params = Parameters()
            params["memberId"] = email
            params["clubId"] = password
            return params
            
        case let .register(name, email, password):
            var params = Parameters()
            params["name"] = name
            params["email"] = email
            params["password"] = password
            
            return params
        case .tokenRefresh:
            var params = Parameters()
            let tokenData = UserDefaultsManager.shared.getTokens()
            return params
        case .userInfo(name: let name, password: let password):
            var params = Parameters()
            params["name"] = name
            params["password"] = password
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
    
    
}
