//
//  UserApiService.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.

import Foundation
import Alamofire
import Combine

// 사용자 관련 api 호출
// 현재 사용자 정보, 모든 사용자 가져오기
enum UserApiService {
    
    // 현재사용자 정보
//    static func fetchCurrentUserInfo() -> AnyPublisher<AuthResponse, AFError>{
//        print("AuthApiService - fetchCurrentUserInfo() called")
//
//
//        let storedTokenData = UserDefaultsManager.shared.getTokens()
//
//
//        let credential = OAuthCredential(requiresRefresh: false, accessToken: storedTokenData.accessToken)
//
//        // Create the interceptor
//        let authenticator = OAuthAuthenticator()
//        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
//                                                        credential: credential)
//
//        return ApiClient.shared.session
//            .request(UserRouter.fetchCurrentUserInfo, interceptor: authInterceptor)
//            .publishDecodable(type: UserInfoResponse.self)
//            .value()
//            .map{ receivedValue in
//                return receivedValue.user
//            }.eraseToAnyPublisher()
//    }
    
    // 모든 사용자 정보
//    static func fetchUsers() -> AnyPublisher<[UserData], AFError>{
//        print("AuthApiService - fetchCurrentUserInfo() called")
//        
//        
//        let storedTokenData = UserDefaultsManager.shared.getTokens()
//        
//
//        let credential = OAuthCredential(requiresRefresh: false, accessToken: storedTokenData.accessToken)
//        
//        // Create the interceptor
//        let authenticator = OAuthAuthenticator()
//        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
//                                                        credential: credential)
//        
//        return ApiClient.shared.session
//            .request(UserRouter.fetchUsers, interceptor: authInterceptor)
//            .publishDecodable(type: UserListResponse.self)
//            .value()
//            .map{ $0.data }.eraseToAnyPublisher()
//    }

    
}
