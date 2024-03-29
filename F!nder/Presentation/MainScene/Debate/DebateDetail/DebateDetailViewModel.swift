//
//  DebateDetailViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/16.
//

import Foundation
import RxSwift

final class DebateDetailViewModel {
    
    struct Input {
        let optionAButtonTrigger = PublishSubject<Void>()
        let optionBButtonTrigger = PublishSubject<Void>()
        let blockUserTrigger = PublishSubject<Int>()
        let reportUserTrigger = PublishSubject<Int>()
        let deleteCommentTrigger = PublishSubject<Int>()
        let addCommentTrigger = PublishSubject<String>()
    }
    
    struct Output {
        var isFilled = BehaviorSubject<Bool>(value: false)
        var answerTableViewDataSource = BehaviorSubject<[Answer]>(value: [])
        var showBlockPopup = PublishSubject<Int>()
        var showReportPopup = PublishSubject<Int>()
        var showDeleteCommentPopup = PublishSubject<Int>()
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    init() {
        self.bind()
    }
    
    func bind() {
        
        self.input.reportUserTrigger
            .subscribe(onNext: { [weak self] userId in
                self?.report(userId: userId)
            })
            .disposed(by: disposeBag)
        
        self.input.deleteCommentTrigger
            .subscribe(onNext: { [weak self] answerId in
                self?.delete(answerId: answerId)
            })
            .disposed(by: disposeBag)
        
        self.input.blockUserTrigger
            .subscribe(onNext: { [weak self] userId in
                self?.block(userId: userId)
            })
            .disposed(by: disposeBag)
        
        
        self.input.addCommentTrigger
            .subscribe(onNext: { [weak self] comment in
                self?.addComment(comment: comment)
            })
            .disposed(by: disposeBag)
        
        self.output.answerTableViewDataSource.onNext(returnAnswerTableViewData())
    }
}

extension DebateDetailViewModel: BottomSheetDelegate {
    func selectedIndex(idx: Int) {
        // TODO: debateUserId 필요
        let debateUserId = 123
        
        // 차단
        if idx == 0 {
            self.output.showBlockPopup.onNext(debateUserId)
        // 신고
        } else if idx == 1 {
            self.output.showReportPopup.onNext(debateUserId)
        }
    }
}

extension DebateDetailViewModel: CommentCellDelegate {
    
    func report(userID: Int) {
        self.output.showReportPopup.onNext(userID)
    }
    
    func delete(commentID: Int) {
        self.output.showDeleteCommentPopup.onNext(commentID)
    }
}

private extension DebateDetailViewModel {
    func report(userId: Int) {
        print("report : \(userId)")
    }
    
    func delete(answerId: Int) {
        print("delete : \(answerId)")
    }
    
    func addComment(comment: String) {
        print("comment: \(comment)")
    }

    func block(userId: Int) {
        print("block: \(userId)")
    }
    
    func returnAnswerTableViewData() -> [Answer] {
        let array = [Answer(answerId: 1,
                            answerContent: "헐 완전 나다 이거",
                            userId: 1,
                            userMBTI: "INFJ",
                            userNickname: "밍밍",
                            createTime: "방금",
                            replyHistDtos: nil),
                     Answer(answerId: 1,
                                         answerContent: "제가 평생 엔팁으로 살아서 그런가 항상 말하기를 좋아했거든요? 그런데 이번에 새로 사귄 동기가 있는데... 사진 보면 아시겠지만 반응은 잘 해주는데 항상 자기 얘기를 안하는 거 같아서 혹시 부담스럽나 싶어서요..ㅠㅠㅠㅠㅜㅠ 의견이 궁금해요...  제가 평생 엔팁으로 살아서 그런가 항상 말하기를 좋아했거든요? 그런데 이번에 새로 사귄 동기가 있는데... 사진 보면 아시겠지만 반응은 잘 해주는데 항상 자기 얘기를 안하는 거 같아서 혹시 부담스럽나 싶어서요..ㅠㅠㅠㅠㅜㅠ 의견이 궁금해요...  이번에 새로 사귄 동기가 있는데에에에에에에에",
                                         userId: 1,
                                         userMBTI: "INFJ",
                                         userNickname: "밍밍",
                                         createTime: "방금",
                                         replyHistDtos: nil),
                     Answer(answerId: 1,
                                         answerContent: "헐 완전 나다 이거",
                                         userId: 1,
                                         userMBTI: "INFJ",
                                         userNickname: "밍밍",
                                         createTime: "방금",
                                         replyHistDtos: nil),
                     Answer(answerId: 1,
                                         answerContent: "제가 평생 엔팁으로 살아서 그런가 항상 말하기를 좋아했거든요? 그런데 이번에 새로 사귄 동기가 있는데... 사진 보면 아시겠지만 반응은 잘 해주는데 항상 자기 얘기를 안하는 거 같아서 혹시 부담스럽나 싶어서요..ㅠㅠㅠㅠㅜㅠ 의견이 궁금해요...  제가 평생 엔팁으로 살아서 그런가 항상 말하기를 좋아했거든요? 그런데 이번에 새로 사귄 동기가 있는데... 사진 보면 아시겠지만 반응은 잘 해주는데 항상 자기 얘기를 안하는 거 같아서 혹시 부담스럽나 싶어서요..ㅠㅠㅠㅠㅜㅠ 의견이 궁금해요...  이번에 새로 사귄 동기가 있는데에에에에에에에",
                                         userId: 1,
                                         userMBTI: "INFJ",
                                         userNickname: "밍밍",
                                         createTime: "방금",
                                         replyHistDtos: nil),
                     Answer(answerId: 1,
                                         answerContent: "헐 완전 나다 이거",
                                         userId: 1,
                                         userMBTI: "INFJ",
                                         userNickname: "밍밍",
                                         createTime: "방금",
                                         replyHistDtos: nil),
                     Answer(answerId: 1,
                                         answerContent: "헐 완전 나다 이거",
                                         userId: 1,
                                         userMBTI: "INFJ",
                                         userNickname: "밍밍",
                                         createTime: "방금",
                                         replyHistDtos: nil),
                     Answer(answerId: 1,
                                         answerContent: "헐 완전 나다 이거",
                                         userId: 1,
                                         userMBTI: "INFJ",
                                         userNickname: "밍밍",
                                         createTime: "방금",
                                         replyHistDtos: nil)
        ]
        return array
    }
}
