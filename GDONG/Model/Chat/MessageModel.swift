//
//  MessageModel.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/24.
//

import Foundation
import UIKit
import MessageKit
import CoreLocation

struct Member {
  let name: String
  let color: UIColor
}

struct Message: MessageType {
    public var sender: SenderType // 보내는 사람
    public var messageId: String // 메세지 하나 id
    public var sentDate: Date // 메시지 날짜
    public var kind: MessageKind // 메제시 종류
}

//struct Media: MediaItem {
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//}
//
//struct Location: LocationItem {
//    var location: CLLocation
//    var size: CGSize
//}

struct Sender: SenderType {
    public var photoURL: String // 보내는 사람 이미지
    public var senderId: String // 보내는 사람 아이디
    public var displayName: String // 보내는 사람 닉네임
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}




extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "customc"
        case .linkPreview(_):
            return "nothing"
        }
        
    }
}
