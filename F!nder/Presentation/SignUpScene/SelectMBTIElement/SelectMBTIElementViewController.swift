//
//  DialogViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/25.
//

import UIKit
import SnapKit
import RxSwift

protocol MBTIElementViewControllerDelegate {
    func selectMBTI(mbti : String)
}

final class SelectMBTIElementViewController: BaseViewController {
    
    let contentView = UIView()
    let titleLabel = FinderLabel(text: "MBTI 선택",
                                font: .systemFont(ofSize: 16.0, weight: .bold),
                                textAlignment: .center)
    let EandIView = MBTIElementView(leftButtonTitle: "E 외향", rightButtonTitle: "I 내향")
    let SandNView = MBTIElementView(leftButtonTitle: "S 현실", rightButtonTitle: "N 직관")
    let TandFView = MBTIElementView(leftButtonTitle: "T 사고", rightButtonTitle: "F 감정")
    let PandJView = MBTIElementView(leftButtonTitle: "P 인식", rightButtonTitle: "J 계획")
    let mbtiStackView = UIStackView()
    
    let closeButton = UIButton()
    let confirmButton = FinderButton(buttonText: "확인")

    var delegate : MBTIElementViewControllerDelegate!
    
    var mbtiArray : [String] = Array(repeating: "z", count: 4) {
        didSet {
            if mbtiArray[0] != "z" && mbtiArray[1] != "z" && mbtiArray[2] != "z" && mbtiArray[3] != "z" {
                enableConfirmButton()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        self.view.addSubview(contentView)
        
        [titleLabel, closeButton, confirmButton, mbtiStackView].forEach {
            contentView.addSubview($0)
        }
        
        [EandIView, SandNView, TandFView, PandJView].forEach {
            mbtiStackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        contentView.snp.makeConstraints {
            $0.width.equalTo(319)
            $0.height.equalTo(460)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32.0)
        }
        
        mbtiStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50.0)
            $0.leading.trailing.equalToSuperview().inset(47.0)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(17.0)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        contentView.backgroundColor = .white
        mbtiStackView.axis = .vertical
        mbtiStackView.spacing = 12.0
        
        closeButton.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
        confirmButton.isEnabled = false
        rxActions()
    }
}

extension SelectMBTIElementViewController {
    
    func rxActions() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let mbti = self?.mbtiArray.joined() else { return }
                self?.delegate.selectMBTI(mbti: mbti)
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    
        EandIView.selectedButtonTitle
            .subscribe(onNext: { [weak self] title in
                self?.mbtiArray[0] = title
            })
            .disposed(by: disposeBag)
        
        SandNView.selectedButtonTitle
            .subscribe(onNext: { [weak self] title in
                self?.mbtiArray[1] = title
            })
            .disposed(by: disposeBag)
        
        TandFView.selectedButtonTitle
            .subscribe(onNext: { [weak self] title in
                self?.mbtiArray[2] = title
            })
            .disposed(by: disposeBag)
        
        PandJView.selectedButtonTitle
            .subscribe(onNext: { [weak self] title in
                self?.mbtiArray[3] = title
            })
            .disposed(by: disposeBag)
    }

    func enableConfirmButton() {
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .primary
        confirmButton.isEnabled = true
    }
}
