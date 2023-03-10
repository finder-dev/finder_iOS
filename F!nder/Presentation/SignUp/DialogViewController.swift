//
//  DialogViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/25.
//

import UIKit
import Then
import SnapKit
import SwiftUI

protocol DialogViewControllerDelegate {
    func sendValue(value : String)
}

class DialogViewController: UIViewController {
    
    let MBTIView = UIView()
    let mainLabel = UILabel()
    let closeButton = UIButton()
    let confirmButton = UIButton()
    let EButton = UIButton()
    let IButton = UIButton()
    let NButton = UIButton()
    let SButton = UIButton()
    let FButton = UIButton()
    let TButton = UIButton()
    let PButton = UIButton()
    let JButton = UIButton()
    
    var delegate : DialogViewControllerDelegate!
    
    var mbtiArray : [String] = Array(repeating: "z", count: 4) {
        didSet {
            if mbtiArray[0] != "z" && mbtiArray[1] != "z" && mbtiArray[2] != "z" && mbtiArray[3] != "z" {
                enableConfirmButton()
            }
        }
    }
    
    var EButtonIsTapped = false {
        didSet {
            if EButtonIsTapped {
                enableButtonState(button: EButton)
                mbtiArray[0] = "E"
            } else {
                disableButtonState(button: EButton)
            }
        }
    }
    var IButtonIsTapped = false {
        didSet {
            if IButtonIsTapped {
                enableButtonState(button: IButton)
                mbtiArray[0] = "I"
            } else {
                disableButtonState(button: IButton)
            }
        }
    }
    var NButtonIsTapped = false {
        didSet {
            if NButtonIsTapped {
                enableButtonState(button: NButton)
                mbtiArray[1] = "N"
            } else {
                disableButtonState(button: NButton)
            }
        }
    }
    var SButtonIsTapped = false {
        didSet {
            if SButtonIsTapped {
                enableButtonState(button: SButton)
                mbtiArray[1] = "S"
            } else {
                disableButtonState(button: SButton)
            }
        }
    }
    var FButtonIsTapped = false {
        didSet {
            if FButtonIsTapped {
                enableButtonState(button: FButton)
                mbtiArray[2] = "F"
            } else {
                disableButtonState(button: FButton)
            }
        }
    }
    var TButtonIsTapped = false {
        didSet {
            if TButtonIsTapped {
                enableButtonState(button: TButton)
                mbtiArray[2] = "T"
            } else {
                disableButtonState(button: TButton)
            }
        }
    }
    var PButtonIsTapped = false {
        didSet {
            if PButtonIsTapped {
                enableButtonState(button: PButton)
                mbtiArray[3] = "P"
            } else {
                disableButtonState(button: PButton)
            }
        }
    }
    var JButtonIsTapped = false {
        didSet {
            if JButtonIsTapped {
                enableButtonState(button: JButton)
                mbtiArray[3] = "J"
            } else {
                disableButtonState(button: JButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        layout()
        attribute()
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapConfirmButton() {
        let mbti = mbtiArray.joined()
        delegate.sendValue(value: mbti)
        self.dismiss(animated: true)
    }
    
    @objc func didTapView() {
        self.dismiss(animated: true)
    }

}

extension DialogViewController {
    func layout() {
        self.view.addSubview(MBTIView)
        
        MBTIView.snp.makeConstraints {
            $0.width.equalTo(319)
            $0.height.equalTo(460)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        [mainLabel,
         closeButton,
         confirmButton,
         EButton,
         IButton,
         NButton,
         SButton,
         FButton,
         TButton,
         JButton,
         PButton].forEach {
            MBTIView.addSubview($0)
        }
        
        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32.0)
        }
        
        EButton.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(50.0)
            $0.leading.equalToSuperview().inset(47.0)
        }
        
        IButton.snp.makeConstraints {
            $0.top.equalTo(EButton)
            $0.leading.equalTo(EButton.snp.trailing)
        }
        
        SButton.snp.makeConstraints {
            $0.top.equalTo(EButton.snp.bottom).offset(12.0)
            $0.leading.equalTo(EButton)
        }
        
        NButton.snp.makeConstraints {
            $0.top.equalTo(SButton)
            $0.leading.equalTo(SButton.snp.trailing)
        }
        
        TButton.snp.makeConstraints {
            $0.top.equalTo(SButton.snp.bottom).offset(12.0)
            $0.leading.equalTo(EButton)
        }
        
        FButton.snp.makeConstraints {
            $0.top.equalTo(TButton)
            $0.leading.equalTo(TButton.snp.trailing)
        }
        
        PButton.snp.makeConstraints {
            $0.top.equalTo(TButton.snp.bottom).offset(12.0)
            $0.leading.equalTo(EButton)
        }
        
        JButton.snp.makeConstraints {
            $0.top.equalTo(PButton)
            $0.leading.equalTo(PButton.snp.trailing)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.centerY.equalTo(mainLabel)
            $0.trailing.equalToSuperview().inset(17.0)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(56.0)
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
        
        EButton.setTitle("E 외향", for: .normal)
        IButton.setTitle("I 내향", for: .normal)
        NButton.setTitle("N 직관", for: .normal)
        SButton.setTitle("S 현실", for: .normal)
        FButton.setTitle("F 감정", for: .normal)
        TButton.setTitle("T 사고", for: .normal)
        PButton.setTitle("P 인식", for: .normal)
        JButton.setTitle("J 계획", for: .normal)
        
        [EButton,
         IButton,
         NButton,
         FButton,
         SButton,
         TButton,
         JButton,
         PButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .regular)
            $0.setTitleColor(.blackTextColor, for: .normal)
            $0.layer.borderColor = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0).cgColor
            $0.layer.borderWidth = 1.0
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 114.0).isActive = true
        }
        
        EButton.addTarget(self, action: #selector(didTapEButton), for: .touchUpInside)
        IButton.addTarget(self, action: #selector(didTapIButton), for: .touchUpInside)
        NButton.addTarget(self, action: #selector(didTapNButton), for: .touchUpInside)
        SButton.addTarget(self, action: #selector(didTapSButton), for: .touchUpInside)
        FButton.addTarget(self, action: #selector(didTapFButton), for: .touchUpInside)
        TButton.addTarget(self, action: #selector(didTapTButton), for: .touchUpInside)
        JButton.addTarget(self, action: #selector(didTapJButton), for: .touchUpInside)
        PButton.addTarget(self, action: #selector(didTapPButton), for: .touchUpInside)
        
    }
    
    @objc func didTapEButton() {
        if !IButtonIsTapped && !EButtonIsTapped {
            EButtonIsTapped = true
        } else {
            if !EButtonIsTapped {
                EButtonIsTapped = true
                IButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapIButton() {
        if !IButtonIsTapped && !EButtonIsTapped {
            IButtonIsTapped = true
        } else {
            if !IButtonIsTapped {
                IButtonIsTapped = true
                EButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapNButton() {
        if !NButtonIsTapped && !SButtonIsTapped {
            NButtonIsTapped = true
        } else {
            if !NButtonIsTapped {
                NButtonIsTapped = true
                SButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapSButton() {
        if !NButtonIsTapped && !SButtonIsTapped {
            SButtonIsTapped = true
        } else {
            if !SButtonIsTapped {
                SButtonIsTapped = true
                NButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapFButton() {
        if !FButtonIsTapped && !TButtonIsTapped {
            FButtonIsTapped = true
        } else {
            if !FButtonIsTapped {
                FButtonIsTapped = true
                TButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapTButton() {
        if !FButtonIsTapped && !TButtonIsTapped {
            TButtonIsTapped = true
        } else {
            if !TButtonIsTapped {
                TButtonIsTapped = true
                FButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapJButton() {
        if !JButtonIsTapped && !PButtonIsTapped {
            JButtonIsTapped = true
        } else {
            if !JButtonIsTapped {
                JButtonIsTapped = true
                PButtonIsTapped = false
            }
        }
    }
    
    @objc func didTapPButton() {
        if !JButtonIsTapped && !PButtonIsTapped {
            PButtonIsTapped = true
        } else {
            if !PButtonIsTapped {
                PButtonIsTapped = true
                JButtonIsTapped = false
            }
        }
    }
    
    func enableButtonState(button: UIButton) {
        button.backgroundColor = .mainTintColor
        button.setTitleColor(.white, for: .normal)
    }
    
    func disableButtonState(button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(.blackTextColor, for: .normal)
    }
    
    func enableConfirmButton() {
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .mainTintColor
        confirmButton.isEnabled = true
    }
}
