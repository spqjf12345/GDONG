//
//  MainModel.swift
//  GDONG
//
//  Created by 이연서 on 2021/04/22.
//

import Foundation

//구매글 데이터 모델 구조
struct Main {
    var productName: String
    var productPrice: String
    var time: String
    var people: Int
    var image: String
}


//판매글 데이터 모델 구조
struct Sell {
    var sellproductName: String
    var sellproductPrice: String
    var selltime: String
    var sellpeople: Int
    var sellimage: String
}
