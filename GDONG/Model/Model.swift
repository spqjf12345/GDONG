//
//  Model.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/21.
//

import Foundation

struct Board {
    var titleBoard: String // 글 제목
    var contentBoard: String // 글 내용
    var dateBoard: String // 글 작성 날짜
    var categoryBoard: String // 글 카테고리
    var price: String //가격
    var viewBoard: Int // 조회수
    var interestBoard: Int // 관심수
    var needPeople: Int // 모집 인원
    var nowPeople: Int // 모집된 인원
    
}

struct User {
    var isNomal: Bool
    var usetName: String
    var userEmail: String
    var userImage: String
    var userLocation: String
    var likePage: [String]
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
