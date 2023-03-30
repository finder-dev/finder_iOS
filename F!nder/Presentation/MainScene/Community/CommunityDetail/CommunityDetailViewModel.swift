//
//  CommunityDetailViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/30.
//

import Foundation
import RxSwift

final class CommunityDetailViewModel {
    
    struct Input {
        let saveButtonTrigger = PublishSubject<Void>()
        let recommendButtonTrigger = PublishSubject<Bool>()
        let addCommentTrigger = PublishSubject<String>()
        let blockUserTrigger = PublishSubject<Int>()
        let reportUserTrigger = PublishSubject<Int>()
    }
    
    struct Output {
        var commentTableViewDataSource = BehaviorSubject<[Answer]>(value: [])
        var showBlockPopup = PublishSubject<Int>()
        var showReportPopup = PublishSubject<Int>()
        var showDeleteCommentPopup = PublishSubject<Int>()
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    var communityId: Int?
    
    init(communityId: Int) {
        self.communityId = communityId
        self.bind()
    }
    
    func bind() {
        
        self.input.saveButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.saveCommunity()
            })
            .disposed(by: disposeBag)
        
        self.input.recommendButtonTrigger
            .subscribe(onNext: { [weak self] isSelected in
                self?.recommendCommunity(isSelected: isSelected)
            })
            .disposed(by: disposeBag)
        
        self.input.addCommentTrigger
            .subscribe(onNext: { [weak self] comment in
                self?.addComment(comment: comment)
            })
            .disposed(by: disposeBag)
        
        self.input.blockUserTrigger
            .subscribe(onNext: { [weak self] userId in
                self?.blockUser(userId: userId)
            })
            .disposed(by: disposeBag)
        
        self.input.reportUserTrigger
            .subscribe(onNext: { [weak self] userId in
                self?.reportUser(userId: userId)
            })
            .disposed(by: disposeBag)
        
        self.output.commentTableViewDataSource.onNext(returnAnswerTableViewData())
    }
}

extension CommunityDetailViewModel: BottomSheetDelegate {
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

extension CommunityDetailViewModel: CommentCellDelegate {
    
    func report(userID: Int) {
        self.output.showReportPopup.onNext(userID)
    }
    
    func delete(commentID: Int) {
        self.output.showDeleteCommentPopup.onNext(commentID)
    }
}

private extension CommunityDetailViewModel {
    func saveCommunity() {
        print("save community")
    }
    
    func recommendCommunity(isSelected: Bool) {
        print("recomment community : \(isSelected)")
    }
    
    func addComment(comment: String) {
        print("add comment: \(comment)")
    }
    
    func reportUser(userId: Int) {
        print("report User: \(userId)")
    }
    
    func blockUser(userId: Int) {
        print("block user: \(userId)")
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
