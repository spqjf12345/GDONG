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
        let board: [Board] = []
//        board.append(Board(title: "샤인 머스켓 나눠 사요", content: "content", date: "2021.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
//       board.append(Board(titleBoard: "title1", contentBoard: "content", dateBoard: "21.04.20", categoryBoard: "과일", price: "20000", viewBoard: 20))
       return board
   }
    
    func Boards(model: [Board]) -> [Board]{
        let boards: [Board] = []
//        boards.append(Board(title: "샤인 머스켓 나눠 사요", content: "content", date: "2021.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "청바지", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
//       boards.append(Board(title: "title1", content: "content", date: "21.04.20", category: "과일", price: "20000", view: 20, interest: 4, needPeople: 5, nowPeople: 1))
        return boards
    }
    
    func oneUser(model: [Users]) -> [Users] {
        let user: [Users] = []
//        user.append(User(isNomal: true, usetName: "조소정", userEmail: "spqjf12345@gmail.com", userImage: "tempImageUrl", userLocation: "분당구", likePage: ["샤인 머스켓", "딸기 공구 합니다"]))
        return user
    }
    
    func categoryList(model : [Category]) -> [Category] {
        var categoryList: [Category] = []
        categoryList.append(Category(categoryImage: "fruits", categoryText: "과일"))
        categoryList.append(Category(categoryImage: "vegetable", categoryText: "야채"))
        categoryList.append(Category(categoryImage: "delivery_blue", categoryText: "배달"))
        categoryList.append(Category(categoryImage: "cosmetic", categoryText: "화장품"))
        categoryList.append(Category(categoryImage: "record", categoryText: "음반"))
        categoryList.append(Category(categoryImage: "oversees_delivery", categoryText: "해외 배송"))
        categoryList.append(Category(categoryImage: "more", categoryText: "기타"))
        return categoryList
    }
    
}

