//
//  FileViewModel.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/12.
//

import Foundation
import Alamofire

class FileViewModel: ObservableObject {
    @Published var folder: Folder?
    
    @Published var file: File?
    
    let baseURL = "http://pocketbox.shop/"
    
    func getFolder<T: Decodable>(name: String, path: [String]) async throws -> T{
        let sessionurl = URL(string: baseURL.appending("folder"))
        print(sessionurl)
        let bodydata: Parameters = [
            "name": name,
            "path": path
        ]
        
        return try await AF.request(sessionurl!, method: .put, parameters: bodydata, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .serializingDecodable()
            .value
    }
    func postFile(name: String, path:[String], filename: String) {
        let sessionurl = URL(string: baseURL.appending("file"))
        print("post File\(name)", sessionurl)
        let bodydata: Parameters = [
            "name": name,
            "path": path,
            "filename": filename
        ]
        AF.request(sessionurl!, method: .post, parameters: bodydata, encoding: JSONEncoding.default)
            .responseDecodable(of:File.self) { response in
                switch response.result {
                case .success(let success):
                    self.file = success
                    print("post Success")
                case .failure(let error):
                    print("file post error")
                    print(error.errorDescription)
                }
            }
    }
    
    func uploadS3(fileURL: URL, filename: String) {
        let sessionurl = URL(string: (self.file?.data.preSigned!)!)
        fileURL.startAccessingSecurityScopedResource()
        AF.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(fileURL, withName: filename)
        }, to: sessionurl!, method: .put)
        .response { response in
            switch response.result {
            case .success(let data) :
                print("success")
                print(data)
            case .failure(let error) :
                print("fail upload")
                print(error)
            }
        }
    }
    
    func postFolder(name: String, path: [String]) {
        let sessionurl = URL(string: baseURL.appending("folder"))
        
        let bodydata: Parameters = [
            "name": name,
            "path": path
        ]
        AF.request(sessionurl!, method: .post, parameters: bodydata, encoding: JSONEncoding.default)
            .responseDecodable(of:File.self) { response in
                switch response.result {
                case .success(let success):
                    self.file = success
                    print("post Success")
                case .failure(let error):
                    print("file post error")
                    print(error.errorDescription)
                }
            }
    }
}
