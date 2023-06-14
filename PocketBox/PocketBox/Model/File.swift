//
//  File.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct File: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: FolderResponse
    
    enum CodingKeys: String, CodingKey {
        case statusCode, responseMessage, data
    }
}

struct Folder: Codable {
    var statusCode: Int?
    var responseMessage: String?
    var data: FolderResponse?
    
    enum CodingKeys: String, CodingKey {
        case statusCode, responseMessage, data
        
    }
}
struct FolderResponse: Codable {
    var preSigned: String?
    var name: [String]?
}
