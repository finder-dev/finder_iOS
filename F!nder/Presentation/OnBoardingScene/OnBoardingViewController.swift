//
//  OnBoardingViewController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import UIKit
import SnapKit

final class OnBoardingViewController: UIViewController {
    
    let titleLabel = FinderLabel(text: "궁금한 MBTI한테\n바로 물어보세요",
                                 font: .systemFont(ofSize: 24.0, weight: .bold),
                                 textColor: .black1)
    let subTitleLabel = FinderLabel(text: "오해와 진실! 여기서 다 풀어요",
                                    font: .systemFont(ofSize: 16.0, weight: .regular),
                                    textColor: .grey2)
 
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let pageControl = UIPageControl()
    let skipButton = UIButton()
    let startButton = FinderButton(buttonText: "시작하기", buttonHeight: 54.0)
    
    let onBoardImages: [UIImage] = [UIImage(named: "img_onboarding1") ?? UIImage(),
                                    UIImage(named: "img_onboarding2") ?? UIImage(),
                                    UIImage(named: "img_onboarding3") ?? UIImage()]
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
}

// MARK: ScrollView delegate

extension OnBoardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
    
    func setPageControlSelectedPage(currentPage:Int) {
        changeView(currentPage)
    }
}

private extension OnBoardingViewController {
    
    func layout() {
        [titleLabel, subTitleLabel, scrollView, pageControl, skipButton, startButton].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
               
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(safeArea).inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        scrollView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(239.0)
        }
        
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom).offset(30)
            $0.height.equalTo(8)
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(39.0)
            $0.width.equalTo(80.0)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalTo(safeArea).inset(30)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
    
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        pageControl.numberOfPages = onBoardImages.count
        pageControl.currentPageIndicatorTintColor = .mainTintColor
        
        for image in onBoardImages {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = false
            imageView.heightAnchor.constraint(equalToConstant: 239).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        
        skipButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        skipButton.setTitleColor(.mainTintColor, for: .normal)
        skipButton.setTitle("SKIP", for: .normal)
        skipButton.isHidden = false
        skipButton.addTarget(self, action: #selector(tapSkipButton), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(tapSkipButton), for: .touchUpInside)
    }
    
    @objc func tapSkipButton() {
        let nextVC = LoginViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func changeView(_ page: Int) {
        pageControl.currentPage = page
        let onBoarding = OnBoarding.getOnBoardingPage(page)
        titleLabel.text = onBoarding.title
        subTitleLabel.text = onBoarding.subTitle
        
        if page == 2 {
            skipButton.isHidden = true
            startButton.isHidden = false
        } else {
            skipButton.isHidden = false
            startButton.isHidden = true
        }
    }
}
