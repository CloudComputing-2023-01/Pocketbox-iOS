//
//  PostViewModel.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation
import Alamofire

class PostViewModel: ObservableObject {
    
    @Published var posts: Post?
    @Published var postDetail: PostDetail?
    @Published var isTapped: Int = 0
    func getPosts<T: Decodable>(url: String) async throws -> T{
        // get, 게시판 불러오기
        //MARK: URL생성, guard let으로 옵셔널 검사
        let sessionUrl = URL(string: url)
        print("get Posts")
        //MARK: Request생성
        //        let token = UserDefaultsManager.shared.getTokens()
        
        return try await AF.request(sessionUrl!,
                                    method: .get, // HTTP메서드 설정
                                    parameters: nil, // 파라미터 설정
                                    encoding: URLEncoding.default, // 인코딩 타입 설정
                                    headers: ["Content-Type":"application/json", "Accept":"application/json"]) // 헤더 설정
        .serializingDecodable()
        .value
        //        return try await AF.request(sessionUrl!,
        //                   method: .get, // HTTP메서드 설정
        //                   parameters: nil, // 파라미터 설정
        //                   encoding: URLEncoding.default, // 인코딩 타입 설정
        //                   headers: ["Content-Type":"application/json", "Accept":"application/json", "x-access-token": token.accessToken]) // 헤더 설정
        //        .serializingDecodable()
        //        .value
    }
    
    func getPostDetail<T: Decodable>(url: String, postId: Int) async throws -> T{
        // get, 게시판 불러오기
        //MARK: URL생성, guard let으로 옵셔널 검사
        let sessionUrl = URL(string: url.appending("/\(postId)"))
        print(sessionUrl)
        //MARK: Request생성
        //        let token = UserDefaultsManager.shared.getTokens()
        
        return try await AF.request(sessionUrl!,
                                    method: .get, // HTTP메서드 설정
                                    parameters: nil, // 파라미터 설정
                                    encoding: URLEncoding.default, // 인코딩 타입 설정
                                    headers: ["Content-Type":"application/json", "Accept":"application/json"]) // 헤더 설정
        .serializingDecodable()
        .value
    }
    
    func deletePost<T: Decodable>(url: String, postId: Int) async throws -> T{
        let sessionUrl = URL(string: url.appending("\(postId)"))
        print("delete Post \(postId)",sessionUrl)
        
        return try await AF.request(sessionUrl!, method: .delete, parameters: nil, encoding: URLEncoding.default).serializingDecodable().value
    }
    
    func editPost<T: Decodable>(url: String, postId: Int, title: String, content: String) async throws -> T {
        let sessionUrl = URL(string: url.appending("\(postId)"))
        print("edit Post \(postId)",sessionUrl)
        
        let bodyData: Parameters = [
            "title": title,
            "content": content
        ]
        
        return try await AF.request(sessionUrl!, method: .put, parameters: bodyData, encoding: JSONEncoding.default).serializingDecodable().value
    }
    
    func likePost(url: String, postId: Int){
        let sessionUrl = URL(string: url.appending("/\(postId)/like"))
        print("like Post \(postId)", sessionUrl)
        
        AF.request(sessionUrl!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": UserDefaultsManager.shared.getTokens().accessToken]).responseDecodable(of: Simpleresponse.self) { response in
            switch response.result {
            case .success :
                print("success like")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func postPost(url: String, title: String, content: String) {
        guard let sessionUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        print("postPost", sessionUrl)
        //MARK: Request생성
        //        let token = UserDefaultsManager.shared.getTokens()
        let bodyData: Parameters = [
            "title": title,
            "content": content
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in bodyData {
                MultipartFormData.append(Data((value as! String).utf8), withName: key)
            }
        }, to: sessionUrl, method: .post, headers: ["Authorization":UserDefaultsManager.shared.getTokens().accessToken])
        .response { response in
            switch response.result {
            case .success(let data) :
                print("Post Success post", data?.description)
            case .failure(let error) :
                print(error.errorDescription)
            }
        }
    }
    
    func postComment<T: Decodable>(url: String, postId: Int, content: String) async throws -> T {
        let sessionUrl = URL(string: url.appending("/comment/\(postId)"))
        
        print("post Comment\(postId)", sessionUrl)
        
        let bodyData: Parameters = [
            "content": content
        ]
        
        return try await AF.request(sessionUrl!, method: .post, parameters: bodyData, encoding:JSONEncoding.default, headers: ["Authorization":UserDefaultsManager.shared.getTokens().accessToken])
            .serializingDecodable().value
    }
    
    func editComment<T: Decodable>(url: String, commentId: Int, content: String) async throws -> T {
        let sessionUrl = URL(string: url.appending("\(commentId)"))
        
        print("post Comment\(commentId)", sessionUrl)
        
        let bodyData: Parameters = [
            "content": content
        ]
        
        return try await AF.request(sessionUrl!, method: .put, parameters: bodyData, encoding:JSONEncoding.default, headers: ["Authorization":UserDefaultsManager.shared.getTokens().accessToken])
            .serializingDecodable().value
    }
    
    func deleteComment<T: Decodable>(url: String, commentId: Int) async throws -> T {
        let sessionUrl = URL(string: url.appending("/comment/\(commentId)"))
        
        print("post Comment\(commentId)", sessionUrl)
        
        return try await AF.request(sessionUrl!, method: .delete, parameters: nil, encoding:JSONEncoding.default)
            .serializingDecodable().value
    }
}
