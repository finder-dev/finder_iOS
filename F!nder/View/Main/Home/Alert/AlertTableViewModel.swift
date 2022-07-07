//
//  AlertTableViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/06.
//

import Foundation
import UIKit

struct AlertTableViewModel {
    let cells : [AlertTableViewCellModel] = [
        AlertTableViewCellModel(image: UIImage(named: "ic_commu")!, title: "ENTP 원래 자기 얘기 안해?", text: "글에 댓글이 달렸습니다.", time: "1시간전"),
        AlertTableViewCellModel(image: UIImage(named: "ic_commu")!, title: "ENTP 원래 자기 얘기 안해?", text: "글에 댓글이 달렸습니다.", time: "1시간전"),
        AlertTableViewCellModel(image: UIImage(named: "ic_vs")!, title: "친구의 깻잎. 19장이 엉겨붙었는데 애인이 떼줘도 된다?", text: "토론에 댓글이 달렸습니다.", time: "1시간전"),
        AlertTableViewCellModel(image: UIImage(named: "ic_vs")!, title: "친구의 깻잎. 19장이 엉겨붙었는데 애인이 떼줘도 된다?", text: "토론에 댓글이 달렸습니다.", time: "1시간전"),
        AlertTableViewCellModel(image: UIImage(named: "ic_vs")!, title: "친구의 깻잎. 19장이 엉겨붙었는데 애인이 떼줘도 된다?", text: "토론에 댓글이 달렸습니다.", time: "1시간전")
    ]
}



struct AlertTableViewCellModel {
    let image : UIImage
    let title : String
    let text : String
    let time : String
}
