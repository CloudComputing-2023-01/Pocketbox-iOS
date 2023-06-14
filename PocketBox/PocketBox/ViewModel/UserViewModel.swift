//
//  UserViewModel.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//

import Foundation
import Alamofire
import Combine

class UserViewModel: ObservableObject {
    
    //MARK: properties
    var subscription = Set<AnyCancellable>()
    
    @Published var userDetail: User?
    
    @Published var isLogined: Bool = false
    
    @Published var loggedInUser: AuthResponse? = nil
    
    @Published var users : [UserData] = []
    
    @Published var email: String = "0" {
        didSet {
            print(email)
        }
    }
    
    @Published var password: String = "0" {
        didSet {
            print(password)
        }
    }
    
    @Published var name: String = "0" {
        didSet {
            print(name)
        }
    }
    
    // 회원가입 완료 이벤트
    var registrationSuccess = PassthroughSubject<(), Never>()
    
    // 로그인 완료 이벤트
    var loginSuccess = PassthroughSubject<(), Never>()
    
    func changeUserInfo(email: String, password: String, name: String) {
        let sessionUrl = URL(string: "http://pocketbox.shop/user/info")
        //MARK: Request생성
        let token = UserDefaultsManager.shared.getTokens().accessToken
        let bodyData: Parameters = [
            "email": self.email,
            "password": self.password,
            "name": self.name
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in bodyData {
                MultipartFormData.append(Data((value as! String).utf8), withName: key)
            }
        }, to: sessionUrl!, method: .put).responseDecodable(of:AuthResponse.self) { response in
            switch response.result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }    }
    
    func getUserInfo<T: Decodable>() async throws ->T {
        let sessionUrl = URL(string: "http://pocketbox.shop/user/info")
        
        let token = UserDefaultsManager.shared.getTokens().accessToken
        print(token)
        return try await AF.request(sessionUrl!, method: .get,
                                    parameters: nil,
                                    encoding: URLEncoding.default,
                                    headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": token])
        .serializingDecodable()
        .value
    }
    
    func postRegister() {
        
        let sessionUrl = URL(string: "http://pocketbox.shop/user/register")
        //MARK: Request생성
        //        let token = UserDefaultsManager.shared.getTokens()
        let bodyData: Parameters = [
            "email": self.email,
            "password": self.password,
            "name": self.name
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in bodyData {
                MultipartFormData.append(Data((value as! String).utf8), withName: key)
            }
        }, to: sessionUrl!).responseDecodable(of:AuthResponse.self) { response in
            switch response.result {
            case .success(let user):
                UserDefaultsManager.shared.setTokens(accessToken: user.data.authorization ?? "")
                print(UserDefaultsManager.shared.getTokens())
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func postLogin() {
        
        let sessionUrl = URL(string: "http://pocketbox.shop/user/login")
        //MARK: Request생성
        //        let token = UserDefaultsManager.shared.getTokens()
        let bodyData: Parameters = [
            "email": self.email,
            "password": self.password,
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in bodyData {
                MultipartFormData.append(Data((value as! String).utf8), withName: key)
            }
        }, to: sessionUrl!).responseDecodable(of:AuthResponse.self) { response in
            switch response.result {
            case .success(let user):
                UserDefaultsManager.shared.setTokens(accessToken: user.data.authorization ?? "")
                self.isLogined = true
                print("success")
                print(user)
                print(user.data)
                print(user.data.authorization ?? "error authorization")
            case .failure(let error):
                print(error)
                self.isLogined = false
            }
        }
    }
    
    /// 회원가입 하기
    func register(name: String, email: String, password: String){
        print("UserVM: register() called")
        AuthApiService.register(name: name, email: email, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserVM completion: \(completion)")
            } receiveValue: { (receivedUser: AuthResponse) in
                self.loggedInUser = receivedUser
                self.registrationSuccess.send()
            }.store(in: &subscription)
    }
    
    /// 로그인 하기
    func login(email: String, password: String){
        print("UserVM: login() called")
        AuthApiService.login(email: email, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserVM completion: \(completion)")
            } receiveValue: { (receivedUser: AuthResponse) in
                self.loggedInUser = receivedUser
                self.loginSuccess.send()
                
            }.store(in: &subscription)
    }
    
    // 현재 사용자 정보 가져오기
    //    func fetchCurrentUserInfo(){
    //        print("UserVM - fetchCurrentUserInfo() called")
    //        UserApiService.fetchCurrentUserInfo()
    //            .sink { (completion: Subscribers.Completion<AFError>) in
    //                print("UserVM fetchCurrentUserInfo completion: \(completion)")
    //            } receiveValue: { (receivedUser: AuthResponse) in
    //                print("UserVM fetchCurrentUserInfo receivedUser: \(receivedUser)")
    //                self.loggedInUser = receivedUser
    //            }.store(in: &subscription)
    //    }
    
    // 모든 사용자 가져오기
    //    func fetchUsers(){
    //        print("UserVM - fetchUsers() called")
    //        UserApiService.fetchUsers()
    //            .sink { (completion: Subscribers.Completion<AFError>) in
    //                print("UserVM fetchUsers completion: \(completion)")
    //            } receiveValue: { (fetchedUsers: [UserData]) in
    //                print("UserVM fetchUsers fetchedUsers.count: \(fetchedUsers.count)")
    //                self.users = fetchedUsers
    //            }.store(in: &subscription)
    //    }
    
}
