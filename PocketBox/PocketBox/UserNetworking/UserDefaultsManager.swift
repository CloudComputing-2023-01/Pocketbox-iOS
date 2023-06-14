//
//  UserDefaultsManager.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct Filedefaults: Codable{
    var fileUrls: [String: URL]
}

class UserDefaultsManager {
    enum Key: String, CaseIterable{
        case accessToken
        case fileUrl
    }
    var fileUrls: Filedefaults = Filedefaults(fileUrls: [:])
    
    let encoder = JSONEncoder()
    
    let decoder = JSONDecoder()
    
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    
    // 저장된 모든 데이터 지우기
    func clearAll(){
        print("UserDefaultsManager - clearAll() called")
        Key.allCases.forEach{ UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
    
    // 토큰들 저장
    func setTokens(accessToken: String){
        print("UserDefaultsManager - setTokens() called")
        UserDefaults.standard.set(accessToken, forKey: Key.accessToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setFiles(fileUrl: URL, fileName: String) {
        print("UserDefaultsManager - setFiles() called")
        let url = fileUrl
        do {
            let url = try fileUrl.asURL()
        } catch {
            print(error)
            
        }
        fileUrls.fileUrls[fileName] = url
        if let encoded = try? encoder.encode(fileUrls){
            UserDefaults.standard.set(fileUrls, forKey: "fileUrls")
        }
        UserDefaults.standard.synchronize()
    }
    
//    func setConstants(clubName: String) {
//        print("UserDefaultsManager - setConstants() called")
//        UserDefaults.standard.set(clubName, forKey: Constants.clubName.rawValue)
//        UserDefaults.standard.synchronize()
//    }
    
    // 토큰들 가져오기
    func getTokens()->TokenData{
        let accessToken = UserDefaults.standard.string(forKey: Key.accessToken.rawValue) ?? ""
        return TokenData(accessToken: accessToken)
    }
    
    func getFiles()->[String:URL] {
        var fileUrls :[String: URL] = [:]
        if let data = UserDefaults.standard.object(forKey: "fileUrls") as? Data {
            if let urls = try? decoder.decode(Filedefaults.self, from: data){
                return urls.fileUrls
            }
        }
        return fileUrls
    }
    
}
