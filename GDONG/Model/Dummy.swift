//
//  Dummy.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/21.
//

import Foundation
class Dummy {
    static let shared = Dummy()
    
    func oneBoardDummy(model: [Board]) -> [Board]{
       var board: [Board] = []
        board.append(Board(profileImage: "strawberry.jpg", title: "샤인 머스켓 나눠 사요", content: "content", date: "2021.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1, likeButton: true))
        board.append(Board(profileImage: "perfume.jpg", title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 4, nowPeople: 4, likeButton: false))
        
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
       return board
   }
    
//    func Boards(model: [Board]) -> [Board]{
//       var boards: [Board] = []
//        boards.append(Board(title: "샤인 머스켓 나눠 사요", content: "content", date: "2021.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "청바지", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//        boards.append(Board(title: "공구해요", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//        boards.append(Board(title: "사과 공구 하실 분", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//        return boards
//    }
    
    func oneUser(model: [User]) -> [User] {
        var user: [User] = []
        user.append(User(isNomal: true, usetName: "조소정", userEmail: "spqjf12345@gmail.com", userImage: "tempImageUrl", userLocation: "분당구", likePage: ["샤인 머스켓", "딸기 공구 합니다"], chatRoomList: [1]))
        return user
    }
    
    func categoryList(model : [Category]) -> [Category] {
        var categoryList: [Category] = []
        categoryList.append(Category(categoryImage: "ct1", categoryText: "과일"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "야채"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "의류"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "배달 음식"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "스낵"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "문구"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "음반"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "과일"))
        categoryList.append(Category(categoryImage: "ct1", categoryText: "마스크"))
        return categoryList
    }
    
}

