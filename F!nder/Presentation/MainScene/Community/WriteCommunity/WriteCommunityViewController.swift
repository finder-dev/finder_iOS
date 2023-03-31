//
//  WriteCommunityViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/09.
//

import UIKit
import SnapKit
import PhotosUI
import RxSwift

/*
 * Community 새 글 작성 view 입니다.
 */
final class WriteCommunityViewController: BaseViewController {
    
    private let completeButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
    private let closeButton = UIBarButtonItem(image: UIImage(named: "ic_baseline-close"), style: .done, target: nil, action: nil)
    private let selectMBTIView = UIView()
    private let selectMBTILabel = FinderLabel(text: "대상 MBTI 선택",
                                      font: .systemFont(ofSize: 14.0, weight: .medium),
                                      textColor: .primary)
    private let selectMBTIImage = UIImageView()
    private let questionButton = UIButton()
    private let titleTextField = UITextField()
    private let lineview = BarView(barHeight: 1.0, barColor: .grey11)
    private let contentTextView = UITextView()
    private let imageCollectionView = ImageCollectionView()
    
    // 사진 등록 components
    var viewModel: WriteCommunityViewModel?
    var picker: PHPickerViewController!
    let albumButton = UIButton()
    var photoImages = [UIImage]()
    let communityNetwork = CommunityAPI()
    var isQuestionButtonTapped = false
    private let textViewPlaceHolder = "내용을 입력하세요.(고민이나 질문을 포함한 글은 상단 궁금 버튼을 눌러주세요!)"
    
    // MARK: - Life Cycle
    
    init(viewModel: WriteCommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        
        [selectMBTIView, questionButton, titleTextField, lineview, contentTextView, albumButton, imageCollectionView].forEach {
            self.view.addSubview($0)
        }
        
        [selectMBTILabel,selectMBTIImage].forEach {
            self.selectMBTIView.addSubview($0)
        }
    }
    
    override func setLayout() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        selectMBTIView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.equalTo(42.0)
            $0.trailing.equalTo(questionButton.snp.leading).offset(-13.0)
        }
        
        questionButton.snp.makeConstraints {
            $0.top.equalTo(selectMBTIView)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        titleTextField.snp.makeConstraints {
            $0.leading.equalTo(selectMBTIView)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(selectMBTIView.snp.bottom)
            $0.height.equalTo(54.0)
        }
        
        lineview.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(lineview.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(titleTextField)
            $0.height.equalTo(300)
        }
        
        albumButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20.0)
            $0.height.width.equalTo(80)
            $0.leading.equalTo(titleTextField)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20.0)
            $0.height.equalTo(80)
            $0.leading.trailing.equalToSuperview()
        }
        
        selectMBTILabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        
        selectMBTIImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(selectMBTILabel)
            $0.height.width.equalTo(24.0)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        title = "글쓰기"
        completeButton.tintColor = .grey13
        closeButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = completeButton
        self.navigationItem.leftBarButtonItem = closeButton
        
        albumButton.isHidden = true
        
        selectMBTIView.layer.cornerRadius = 21.0
        selectMBTIView.layer.borderColor = UIColor.primary.cgColor
        selectMBTIView.layer.borderWidth = 1.0
        
        questionButton.setImage(UIImage(named: "Group 986375"), for: .normal)
        questionButton.setImage(UIImage(named: "Group 986359"), for: .selected)
        questionButton.changesSelectionAsPrimaryAction = true
        questionButton.isSelected = false
        
        titleTextField.placeholder = "제목을 입력하세요."
        contentTextView.backgroundColor = .white
        contentTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
        contentTextView.textColor = .grey3
        contentTextView.text = textViewPlaceHolder

        selectMBTIImage.image = UIImage(named: "header_login")

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .any(of: [.images])
        self.picker = PHPickerViewController(configuration: configuration)
        picker?.delegate = self
    }
    
    override func bindViewModel() {
        completeButton.rx.tap
            .subscribe(onNext: { [weak self] in
               
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPopUp2(title: "작성을 취소하시겠습니까?",
                                 message: "",
                                 leftButtonText: "네", rightButtonText: "아니오",
                                 leftButtonAction: {
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonAction: { })
                
            })
            .disposed(by: disposeBag)
        
        selectMBTIView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let nextVC = SelectMBTIViewController(viewCase: .withoutEvery)
                nextVC.delegate = self
                self?.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        titleTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [weak self] _ in
                self?.contentTextView.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        contentTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                if self?.contentTextView.text == self?.textViewPlaceHolder {
                    self?.contentTextView.text = nil
                    self?.contentTextView.textColor = .black
                }
            })
            .disposed(by: disposeBag)

        contentTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                guard let text = self?.contentTextView.text else { return }

                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self?.contentTextView.text = self?.textViewPlaceHolder
                    self?.contentTextView.textColor = .lightGray
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        self.viewModel?.output.imageCollectionViewDataSource
            .bind(to: imageCollectionView.rx.items(cellIdentifier: ImageCollectionViewCell.reuseIdentifier, cellType: ImageCollectionViewCell.self)) { index, item, cell in
                if index == 0 {
                    cell.eraseButton.isHidden = true
                }
                cell.setupCell(data: item)
            }
            .disposed(by: disposeBag)
        
        imageCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if indexPath.row == 0 {
                    guard let picker = self?.picker else { return }
                    self?.present(picker, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

// 사진 불러오기
extension WriteCommunityViewController : PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        var selectedImage : UIImage?
        
        var images = [UIImage(named: "Group 986367") ?? UIImage()]
        
        picker.dismiss(animated: true, completion: nil)
        
//        if !results.isEmpty {
//            for result in results {
//                let itemProvider = result.itemProvider
//
//                if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                        if let image = image as? UIImage {
//                            images.append(image)
//                        }
//                    }
//                }
//            }
//            self.viewModel?.output.imageCollectionViewDataSource.onNext(im)
//        }
        
        
        // 3.
        let itemProvider = results.first?.itemProvider // 4.
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 5.
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in // 6.
                if let image = image as? UIImage {
                    images.append(image)
                    self.viewModel?.output.imageCollectionViewDataSource.onNext(images)
                }
//                DispatchQueue.main.async { //
                    
//                    guard let selectedImage = image as? UIImage else { return }
//                    let uploadViewController = UploadViewController(uploadImage: selectedImage)
//                    let navigationController = UINavigationController(rootViewController: uploadViewController)
//                    navigationController.modalPresentationStyle = .fullScreen
//                    self.present(navigationController, animated: true, completion: nil)
//                }
            }
        }
    }
}

// 선택한 MBTI 보여주기
extension WriteCommunityViewController: SelectMBTIViewControllerDelegate {
    
    func selectedMBTI(mbti: String) {
        selectMBTILabel.text = mbti
    }

    @objc func didTapCompleteButton() {
        guard let title = titleTextField.text,
              let content = contentTextView.text,
              let mbti = selectMBTILabel.text  else {
            return
        }
        
        communityNetwork.requestNewCommunity(title: title,
                                             content: content,
                                             mbti: mbti,
                                             isQuestion: isQuestionButtonTapped) { [self] result in

            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 글 작성")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("실패 : 커뮤니티 글 작성")
                    DispatchQueue.main.async {
                        showPopUp1(title: "글 작성 실패",
                                   message: response.errorResponse?.errorMessages[0] ?? "글 작성에 실패하였습니다.",
                                   buttonText: "확인", buttonAction: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}
