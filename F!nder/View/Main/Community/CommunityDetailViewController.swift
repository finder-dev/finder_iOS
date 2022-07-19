//
//  CommunityDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import UIKit
import SnapKit

class CommunityDetailViewController: UIViewController {
    
    let headerView = UIView()
    let questionImageView = UIImageView()
    let mbtiCategoryLabel = UILabel()
    let titleLabel = UILabel()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
    let saveButton = UIButton()
    
    let lineView = UIView()
    let contentLabel = UILabel()
    let lineView2 = UIView()
    let emptyView = UIView()
    var communityId : Int?

    let communityNetwork = CommunityAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        setupHeaderView()
        guard let communityId = communityId else {
            return
        }
        print("communityId : \(communityId)")
        
        communityNetwork.requestCommunityDetail(communityID: communityId) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 상세 조회 ")

                    guard let response = response.response  else {
                        return
                    }

                    print(response)
                    DispatchQueue.main.async {
                        self.addData(data: response)
                    }
                } else {
                    print("실패 : 커뮤니티 상세 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func addData(data: DetailCommunitySuccessResponse) {
        mbtiCategoryLabel.text = data.communityMBTI
        timeLabel.text = data.createTime
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
        titleLabel.text = data.communityTitle
        contentLabel.text = data.communityContent
        
        
        if !data.isQuestion {
            questionImageView.isHidden = true
        }
        
        if data.saveUser {
            saveButton.setImage(UIImage(named: "saved"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        }
    }
}

extension CommunityDetailViewController {
    func layout() {
        
        [headerView,
         mbtiCategoryLabel,
         questionImageView,
         titleLabel,
         userMBTILabel,
         userNameLabel,
         timeLabel,
         lineView,
         contentLabel,
         lineView2].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(48.0)
        }
        
        mbtiCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.equalTo(43.0)
            $0.height.equalTo(30.0)
        }
        
        questionImageView.snp.makeConstraints {
            $0.centerY.equalTo(mbtiCategoryLabel)
            $0.leading.equalTo(mbtiCategoryLabel.snp.trailing).offset(8.0)
            $0.width.equalTo(47.0)
            $0.height.equalTo(34.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mbtiCategoryLabel.snp.bottom).offset(20.0)
            $0.height.equalTo(26.0)
            $0.leading.equalTo(mbtiCategoryLabel)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(mbtiCategoryLabel)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userMBTILabel)
            $0.leading.equalTo(userMBTILabel.snp.trailing)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(userMBTILabel)
        }
        
        lineView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(userMBTILabel.snp.bottom).offset(20.0)
            $0.height.equalTo(1.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        lineView2.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(contentLabel.snp.bottom).offset(31.5)
            $0.height.equalTo(1.0)
        }
        
        

         questionImageView.image = UIImage(named: "Group 986359")
         
         mbtiCategoryLabel.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
         mbtiCategoryLabel.layer.cornerRadius = 5.0
         mbtiCategoryLabel.textColor = .blackTextColor
         mbtiCategoryLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
         mbtiCategoryLabel.textAlignment = .center
        
        titleLabel.textColor = .blackTextColor
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        contentLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        contentLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        contentLabel.numberOfLines = 0

        [lineView,lineView2].forEach {
            $0.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        }

        [userMBTILabel,userNameLabel,timeLabel].forEach {
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }

    }
    
    func setupHeaderView() {
        let headerLabel = UILabel()
        let backButton = UIButton()
        
        [headerLabel,backButton,saveButton].forEach {
            headerView.addSubview($0)
        }
        
        headerLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(headerLabel)
        }
        
        saveButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(headerLabel)
        }
        
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

        headerLabel.text = "커뮤니티"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSaveButton() {
        print("didTapSaveButton")
        
        communityNetwork.requestSave(communityID: communityId!) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 글 저장 ")

                    guard let response = response.response  else {
                        return
                    }
                    if response.message == "save success" {
                        DispatchQueue.main.async {
                            saveButton.setImage(UIImage(named: "saved"), for: .normal)
                        }
                    } else {
                        DispatchQueue.main.async {
                            saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
                        }
                    }
                    print(response.message)
                    
                } else {
                    print("실패 : 커뮤니티 글 저장")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}

