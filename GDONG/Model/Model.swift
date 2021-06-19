//
//  Model.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/21.
//

import Foundation

struct Board {
    var profileImage: String
    var title: String // 글 제목
    var content: String // 글 내용
    var date: String // 글 작성 날짜
    var category: String // 글 카테고리
    var price: String //가격
    var view: Int // 조회수
    var interest: Int // 관심수
    var needPeople: Int // 모집 인원
    var nowPeople: Int // 모집된 인원
    var likeButton: Bool // 좋아요 한 글
    
}


struct User: Codable {
    var __v: Int
    var _id: String
    var email: String // 유저 이메일
    var name: String //유저 네임
    var authProvider: String //소셜 로그인 정보
    var isSeller: Bool //판매 권한
    var chatRoomList: [Int] // 참여 중인 채팅 방 ID
    var recentHistory: [String] // 최근 검색어
    var nickName: String //유저 닉네임
    var profileImageUrl: String // 유저 프로필 이미지 url
    var followers: [String] //내가 follow 하는 nickName
    var following: [String] //내가 following 하는 사람
    var createdAt: String
    var updatedAt: String
    var deviceToken: String
    //유저 위치
    var latitude: Int
    var longitude: Int
    var posts:[Int]
    var likes: [Int]
    
    enum CodingKeys: String, CodingKey {
        case __v
        case _id
        case email
        case name
        case authProvider
        case isSeller
        case chatRoomList = "chatroomList"
        case recentHistory
        case nickName = "nickname"
        case profileImageUrl
        case followers
        case following
        case createdAt
        case updatedAt
        case deviceToken
        case latitude
        case longitude
        case posts
        case likes

    }
}

//juso
struct JusoResponse: Codable {
    var results: JusoResults!
}

struct JusoResults: Codable {
    var common: Common!
    var juso: [Juso]!
}

struct Common: Codable {
    var errorCode: String!
    var currentPage: String!
    var totalCount: String!
    var errorMessage: String!
}

struct Juso: Codable {
    var roadAddr: String!
    var jibunAddr: String!
}

struct Category {
    var categoryImage: String
    var categoryText: String
}
