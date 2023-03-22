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
    func selectedMBTI(mbti : String)
}

enum SelectMBTIViewCase {
    case withEvery
    case withoutEvery
}

final class SelectMBTIViewController: BaseViewController {
    
    let MBTIView = UIView()
    let titleLabel = FinderLabel(text: "MBTI 선택",
                                font: .systemFont(ofSize: 16.0, weight: .bold),
                                textColor: .black1,
                                textAlignment: .center)
    let closeButton = UIButton()
    let confirmButton = UIButton()
    let buttonCollectionView = MBTICollectionView()
    
    var delegate: SelectMBTIViewControllerDelegate?
    var selectedMBTI: String = ""
    var mbtiButtons: [MBTI] = MBTI.allCases
    
    convenience init(viewCase: SelectMBTIViewCase) {
        self.init()
        
        if viewCase == .withoutEvery {
            mbtiButtons.remove(at: 0)
        }
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        self.view.addSubview(MBTIView)
        
        [titleLabel, closeButton, confirmButton, buttonCollectionView].forEach {
            MBTIView.addSubview($0)
        }
    }
    
    override func setLayout() {
        MBTIView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(94.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerX.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
            $0.height.equalTo(23.0)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(58.0)
        }
        
        buttonCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        MBTIView.backgroundColor = .white
    
        closeButton.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
        closeButton.setTitleColor(.black1, for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.grey8, for: .disabled)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        confirmButton.backgroundColor = .grey7
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        confirmButton.isEnabled = false
        
        buttonCollectionView.delegate = self
        buttonCollectionView.dataSource = self
    }
}

extension SelectMBTIViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mbtiButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.reuseIdentifier, for: indexPath) as? MBTICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let button = mbtiButtons[indexPath.row]
        cell.setupCell(data: button)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = mbtiButtons[indexPath.row]
        selectedMBTI = selected.rawValue
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = .primary
    }
}

private extension SelectMBTIViewController {
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: false)
    }
    
    @objc func didTapConfirmButton() {
        delegate?.selectedMBTI(mbti: selectedMBTI)
        self.dismiss(animated: false)
    }
}
