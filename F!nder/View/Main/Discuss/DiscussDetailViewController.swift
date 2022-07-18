//
//  DiscussDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/14.
//

import UIKit
import SnapKit

/*
 * 토론 상세 뷰 입니다.
 */
class DiscussDetailViewController: UIViewController {
    
    // 토론 내용 보여주는 components
    let discussView = UIView()
    let discussTitle = UILabel()
    let timeLabel = UILabel()
    var agreeButton = UIButton()
    var agreeCounts = UILabel()
    var disagreeButton = UIButton()
    var disagreeCounts = UILabel()
    var agreeImageView = UIImageView()
    var disagreeImageView = UIImageView()
    var userMBTILabel = UILabel()
    var userNameLabel = UILabel()
    var commentCountLabel = UILabel()
    
    var emptyView = UIView()
    var debateID : Int?
    let debateNetwork = DebateAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        attribute()
        guard let debateID = debateID else {
            return
        }
        print(debateID)
        fetchDebateData(debateID: debateID)
    }
    
    func fetchDebateData(debateID: Int) {
        debateNetwork.requestDebateDetail(debateID: debateID) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 상세 조회")
                    guard let response = response.response else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.addData(data: response)
                    }
                } else {
                    print("실패 : 토론 상세 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func addData(data:DetailDebateSuccessResponse) {
        discussTitle.text = data.debateTitle
        timeLabel.text = "남은시간 \(data.deadline)"
        commentCountLabel.text = "댓글 \(data.answerCount)"
        userMBTILabel.text = data.writerMBTI
        userNameLabel.text = data.writerNickname
        agreeCounts.text = "\(data.optionACount)"
        agreeButton.setTitle(data.optionA, for: .normal)
        disagreeButton.setTitle(data.optionB, for: .normal)
        print(data)
        if data.join {
            if data.joinOption == "A" {
                agreeImageView.isHidden = false
                disagreeImageView.isHidden = true
                agreeButton.backgroundColor = .selectedDebateColor
            } else if data.joinOption == "B" {
                disagreeImageView.isHidden = false
                agreeImageView.isHidden = true
                disagreeButton.backgroundColor = .selectedDebateColor
            }
        }
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

extension DiscussDetailViewController {
    
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton")
        
    }
    
}

private extension DiscussDetailViewController {
    func layout() {
        [discussView,emptyView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        discussView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
        }
        
        emptyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(discussView.snp.bottom)
            $0.height.equalTo(10.0)
        }
        
        discussView.backgroundColor = .white
        emptyView.backgroundColor = UIColor(red: 233/255, green: 234/255, blue: 239/255, alpha: 1.0)
        setupNavigationAttribute()
        setupDiscussViewLayout()
    }
    
    
    func attribute() {
        // 233 234 239
        self.view.backgroundColor = .white
        setupNavigationAttribute()
        setupDiscussViewAttribute()
    }
}

extension DiscussDetailViewController {
    func setupDiscussViewLayout() {
        
        [discussTitle,
         timeLabel,
         agreeCounts,
         agreeImageView,
         disagreeCounts,
         disagreeImageView,
         commentCountLabel,
         disagreeButton,
         agreeButton,
         userMBTILabel,
         userNameLabel].forEach {
            discussView.addSubview($0)
        }
        
        let screenWidth = self.view.bounds.width
        let buttonWidth = (screenWidth - (20*2 + 13.0)) / 2
        let buttonHeight = 55.0
        
        discussTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(73.0)
            $0.top.equalToSuperview().inset(24.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(discussTitle.snp.bottom).offset(4.0)
        }
        
        agreeCounts.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(screenWidth/2+22.0)
            $0.height.equalTo(64.0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(32.0)
        }
        
        agreeImageView.snp.makeConstraints {
            $0.bottom.equalTo(agreeButton.snp.top)
            $0.leading.equalTo(agreeButton)
        }
        
        disagreeImageView.snp.makeConstraints {
            $0.bottom.equalTo(disagreeButton.snp.top)
            $0.trailing.equalTo(disagreeButton)
        }
        
        disagreeCounts.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(screenWidth/2+22.0)
            $0.height.equalTo(64.0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(32.0)
        }
        
        agreeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            $0.top.equalTo(timeLabel.snp.bottom).offset(75.0)
        }
        
        disagreeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            $0.top.equalTo(timeLabel.snp.bottom).offset(75.0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.top.equalTo(disagreeButton.snp.bottom).offset(37.0)
            $0.centerY.equalTo(commentCountLabel)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userMBTILabel.snp.trailing).offset(20.0)
            $0.centerY.equalTo(userMBTILabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview().inset(20.0)
        }
    }
    
    func setupDiscussViewAttribute() {
        discussTitle.font = .systemFont(ofSize: 16.0, weight: .medium)
        discussTitle.textColor = .blackTextColor
        discussTitle.textAlignment = .center
        discussTitle.numberOfLines = 0
        
        [commentCountLabel,timeLabel,userMBTILabel,userNameLabel].forEach {
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        }
        
        timeLabel.textAlignment = .center
        
        [agreeCounts,disagreeCounts].forEach {
            $0.font = .systemFont(ofSize: 44.0, weight: .bold)
            $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            $0.text = "33"
            $0.textAlignment = .center
        }
        
        agreeButton.setTitle("물론 가능!", for: .normal)
        disagreeButton.setTitle("절대 불가능", for: .normal)
        
        [agreeButton,disagreeButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.setTitleColor(UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0), for: .normal)
            $0.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        }
        
        agreeButton.contentHorizontalAlignment = .left
        disagreeButton.contentHorizontalAlignment = .right
        
        agreeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        disagreeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
        
        
        [agreeImageView,disagreeImageView].forEach {
            $0.image = UIImage(named: "Frame 986295")
            $0.isHidden = true
        }
    }
    func setupNavigationAttribute() {
        self.navigationController?.navigationBar.isHidden = false
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icon-siren-mono"), style: .plain, target: self, action: #selector(didTapRightBarButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let backButton  = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .blackTextColor
        self.navigationItem.title = "토론"
    }
}
