//
//  HomeCommunityTableViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/07.
//

import Foundation

struct HomeCommunityTableViewModel {
    let cells : [HomeCommunityTableViewCellModel] = [
        HomeCommunityTableViewCellModel(number: "1", title: "엔팁한테 사과받았다 대박!!!!!!!!"),
        HomeCommunityTableViewCellModel(number: "2", title: "엔팁한테 사과받았다 대박!!!!!!!!"),
        HomeCommunityTableViewCellModel(number: "3", title: "엔팁한테 사과받았다 대박!!!!!!!!"),
        HomeCommunityTableViewCellModel(number: "4", title: "엔팁한테 사과받았다 대박!!!!!!!!"),
        HomeCommunityTableViewCellModel(number: "5", title: "엔팁한테 사과받았다 대박!!!!!!!!")
    ]
}

struct HomeCommunityTableViewCellModel {
    let number : String
    let title : String
}
