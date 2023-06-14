//
//  OAuthAuthenticate.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//
import Foundation
import Alamofire


class OAuthAuthenticator : Authenticator {
    func refresh(_ credential: OAuthCredential, for session: Alamofire.Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        return
    }
    
   
    // 헤더에 인증 추가
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
            // 헤더에 Authrization 키로 Bearer 토큰값
            urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        
            // 만약에 커스텀이면
//            urlRequest.headers.add(name: "ACCESS_TOKEN", value: credential.accessToken)
        }

    // api 요청 완료
    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        
        print("OAuthAuthenticator - didRequest() called")
        
        // 401 코드가 떨어지면 리프레시 토큰으로 액세스 토큰을 재발행 하라고 요청
        switch response.statusCode {
            case 401: return true
            default: return false
        }
        
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        // If authentication server CANNOT invalidate credentials, return `true`
        return true

        // If authentication server CAN invalidate credentials, then compare the "Authorization" header value in the
        // `URLRequest` against the Bearer token generated with the access token of the `Credential`.
        // let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        // return urlRequest.headers["Authorization"] == bearerToken
    }
}

