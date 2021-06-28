//
//  ChatListModel.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/28.
//

import Foundation

//채팅목록 데이터 구조
struct ChatList {
    var roomName: String
    var thumnail: String
    var latestMessageTime: String
    var message: String
}


//sj
struct ChatRoom {
    var id: String
    var roomName: String // 채팅 방 이름 ( 글 제목 그대로 가져옴 )
    var thumbnail: String // 채팅 방 이미지
    var parcipants: [String] // 참여 중인 user id
    let latestMessage: LatestMessage // 최근 메세지
    var messages: [Message] // 메세지 객체 -> MessageModel에서 확인 가능
    var allowedNotification: Bool // 알림 허용 여부
}


