//
//  Boaard.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import Foundation

struct Post: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: [PostDetail]?
    
    enum CodingKeys: CodingKey {
        case statusCode, responseMessage, data
    }
}

struct PostDetail: Codable, Hashable {
    var postId: Int
    var name: String
    var title: String
    var content: String
    var likeCount: Int
    var createdAt: String
    var updatedAt: String
    var commentDtoList: [CommentDtoList]?
    enum CodingKeys: CodingKey {
        case postId, name, title, content, likeCount, createdAt, updatedAt, commentDtoList
    }
}

struct PostDetailContent: Codable, Hashable {
    var statusCode: Int?
    var responseMessage: String?
    var data: PostDetail
    
    enum CodingKeys: CodingKey {
        case statusCode, responseMessage, data
    }
}

struct CommentDtoList: Codable, Hashable {
    var commentId: Int
    var name: String
    var content: String
    var createdAt: String
    var updatedAt: String?
}
