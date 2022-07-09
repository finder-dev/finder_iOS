//
//  SelectMBTIViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/09.
//

import UIKit
import SnapKit

/*
 * MBTI를 선택하는 view입니다.
 */

protocol SelectMBTIViewControllerDelegate {
    func sendValue(value : String)
}

class SelectMBTIViewController: UIViewController {
    
    let MBTIView = UIView()
    let mainLabel = UILabel()
    let closeButton = UIButton()
    let confirmButton = UIButton()
    
    let ISTJButton = UIButton()
    let ISFJButton = UIButton()
    let INFJButton = UIButton()
    let INTJButton = UIButton()
    let ISTPButton = UIButton()
    let ISFPButton = UIButton()
    let INFPButton = UIButton()
    let INTPButton = UIButton()
    
    let ESTPButton = UIButton()
    let ESFPButton = UIButton()
    let ESTJButton = UIButton()
    let ESFJButton = UIButton()
    let ENTPButton = UIButton()
    let ENFPButton = UIButton()
    let ENFJButton = UIButton()
    let ENTJButton = UIButton()
    
    let mbtiViewWidth: CGFloat = 335.0
    var selectedMBTI : String = ""
    var selectedButton = [UIButton]()
    var delegate : SelectMBTIViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        layout()
        attribute()
    }
}

private extension SelectMBTIViewController {
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapConfirmButton() {
        delegate.sendValue(value: selectedMBTI)
        self.dismiss(animated: true)
    }
    
    @objc func didTapMBTIButton(sender: UIButton) {
        if !selectedButton.isEmpty {
            isDeselected(button: selectedButton.first!)
            selectedButton.removeFirst()
        }
        isSelected(button: sender)
        selectedButton.append(sender)
    }
    
    func isSelected(button:UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainTintColor
        
        guard let mbti = button.title(for: .normal) else {
            print("오류 - selectMBTI dialLog : mbti가 버튼에 지정되어 있지 않습니다.")
            return
        }
        selectedMBTI = mbti
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = .mainTintColor
        confirmButton.setTitleColor(.white, for: .normal)
    }
    
    func isDeselected(button:UIButton) {
        button.setTitleColor(UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0), for: .normal)
        button.backgroundColor = .white
    }
}

private extension SelectMBTIViewController {
    func layout() {
        self.view.addSubview(MBTIView)
        
        MBTIView.snp.makeConstraints {
            $0.width.equalTo(mbtiViewWidth)
            $0.height.equalTo(553)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        [mainLabel,
         closeButton,
         confirmButton,
         ISTJButton,
         ISFJButton,
         ISTPButton,
         ISFPButton,
         INTJButton,
         INFJButton,
         INTPButton,
         INFPButton,
         ESTJButton,
         ESFJButton,
         ESTPButton,
         ESFPButton,
         ENTPButton,
         ENFPButton,
         ENTJButton,
         ENFJButton
        ].forEach {
            MBTIView.addSubview($0)
        }
        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.centerY.equalTo(mainLabel)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(58.0)
        }
    
        ISTJButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(mainLabel.snp.bottom).offset(16.0)
        }
        
        ISFJButton.snp.makeConstraints {
            $0.leading.equalTo(ISTJButton.snp.trailing)
            $0.top.equalTo(ISTJButton)
            $0.trailing.equalToSuperview()
        }
        
        INFPButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(ISTJButton.snp.bottom)
        }
    }
    
    func attribute() {
        MBTIView.backgroundColor = .white
        
        mainLabel.text = "MBTI 선택"
        mainLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        mainLabel.textAlignment = .center
        mainLabel.textColor = .blackTextColor
        
        closeButton.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
        closeButton.setTitleColor(.blackTextColor, for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.unabledButtonTextColor, for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        confirmButton.backgroundColor = .unabledButtonColor
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        confirmButton.isEnabled = false
                
        let buttonWidth = self.mbtiViewWidth/2
        let buttonHeight :CGFloat = 54.5
        
        [ISTJButton,
         ISFJButton,
         ISTPButton,
         ISFPButton,
         INTJButton,
         INFJButton,
         INTPButton,
         INFPButton,
         ESTJButton,
         ESFJButton,
         ESTPButton,
         ESFPButton,
         ENTPButton,
         ENFPButton,
         ENTJButton,
         ENFJButton].forEach {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
            $0.setTitleColor(UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
            $0.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            $0.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            $0.addTarget(self, action: #selector(didTapMBTIButton(sender:)), for: .touchUpInside)
        }

        ISTJButton.setTitle("ISTJ", for: .normal)
        ISFJButton.setTitle("ISFJ", for: .normal)
        ISTPButton.setTitle("ISTP", for: .normal)
        ISFPButton.setTitle("ISFP", for: .normal)
        INTJButton.setTitle("INTJ", for: .normal)
        INFJButton.setTitle("INFJ", for: .normal)
        INTPButton.setTitle("INTP", for: .normal)
        INFPButton.setTitle("INFP", for: .normal)
        ESTJButton.setTitle("ESTJ", for: .normal)
        ESFJButton.setTitle("ESFJ", for: .normal)
        ESTPButton.setTitle("ESTP", for: .normal)
        ESFPButton.setTitle("ESFP", for: .normal)
        ENTPButton.setTitle("ENTP", for: .normal)
        ENFPButton.setTitle("ENFP", for: .normal)
        ENTJButton.setTitle("ENTJ", for: .normal)
        ENFJButton.setTitle("ENFJ", for: .normal)
    }
}
