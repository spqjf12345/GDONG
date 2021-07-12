//
//  ChatUser.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/29.
//


import Foundation
import MessageKit
struct ChatUser: SenderType, Equatable {
    var senderId: String // send email
    var displayName: String
}
