//
//  WriteCommunityViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/09.
//

import UIKit
import SnapKit
import PhotosUI

/*
 * Community 새 글 작성 view 입니다.
 */
class WriteCommunityViewController: UIViewController, AlertMessage2Delegate {
    func leftButtonTapped(from: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightButtonTapped(from: String) {
    }
    
    
    // headerView components
    let headerView = UIView()
    let headerLabel = UILabel()
    let closeButton = UIButton()
    let completeButton = UIButton()
    
    // mbti 선택 view components
    let selectMBTIView = UIView()
    let selectMBTILabel = UILabel()
    let selectMBTIImage = UIImageView()
    let questionButton = UIButton()
    
    // 글 작성 components
    let titleTextField = UITextField()
    let lineview = UIView()
    let contentTextView = UITextView()
    let textViewPlaceHolder = "내용을 입력하세요.(고민이나 질문을 포함한 글은 상단 궁금 버튼을 눌러주세요!)"
    
    // 사진 등록 components
    var picker: PHPickerViewController!
    let albumButton = UIButton()
    var photoImages = [UIImage]()
    
    let communityNetwork = CommunityAPI()
    
    var isQuestionButtonTapped = false {
        didSet {
            if isQuestionButtonTapped {
                questionButton.setImage(UIImage(named: "Group 986359"), for: .normal)
            } else {
                questionButton.setImage(UIImage(named: "Group 986375"), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        setupNavigationBar()
        layout()
        attribute()
        contentTextView.backgroundColor = .white
        setUpPHPickerVC()
        albumButton.isHidden = true
    }
    
    //옵저버 등록
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 옵저버 해제
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// 사진 불러오기
extension WriteCommunityViewController : PHPickerViewControllerDelegate {
    func setUpPHPickerVC() {
        configurePickerView()
        picker.delegate = self
    }
    
    
    func configurePickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        self.picker = PHPickerViewController(configuration: configuration)
//        self.present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        var selectedImage : UIImage?
        picker.dismiss(animated: true, completion: nil) // 3.
        
        
        if !results.isEmpty {
            photoImages.removeAll()
            
            for result in results {
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        
                        guard let image = image as? UIImage else {
                            print("오류 - WriteCommunityVC : UIImage 변환 실패")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.albumButton.setImage(image, for: .normal)
                        }
//                        self.photoImages.append(image)
                    }
                }
            }
        }
//        let itemProvider = results.first?.itemProvider // 4.
//        if let itemProvider = itemProvider,itemProvider.canLoadObject(ofClass: UIImage.self) { // 5.
//            itemProvider.loadObject(ofClass: UIImage.self) { image, error in // 6.
//                DispatchQueue.main.async { //
//                    guard let selectedImage = image as? UIImage else { return }
//                    let uploadViewController = UploadViewController(uploadImage: selectedImage)
//                    let navigationController = UINavigationController(rootViewController: uploadViewController)
//                    navigationController.modalPresentationStyle = .fullScreen
//                    self.present(navigationController, animated: true, completion: nil)
//                }
//            }
//        }
    }
}

// 선택한 MBTI 보여주기
extension WriteCommunityViewController :SelectMBTIViewControllerDelegate {
    
    func selectedMBTI(mbti: String) {
        selectMBTILabel.text = mbti
    }
    
    @objc func didTapCloseButton() {
        presentCutomAlert2VC(target: "delete", title: "작성을 취소하시겠습니까?", message: "", leftButtonTitle: "네", rightButtonTitle: "아니요")
    }
    
    func presentCutomAlert2VC(target:String,
                              title:String,
                              message:String,
                              leftButtonTitle:String,
                              rightButtonTitle:String) {
        let nextVC = AlertMessage2ViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.leftButtonTitle = leftButtonTitle
        nextVC.rightButtonTitle = rightButtonTitle
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
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
                        self.presentCutomAlertVC(target: "writeCommunity", title: "글 작성 실패", message: response.errorResponse?.errorMessages[0] ?? "글 작성에 실패하였습니다.")
                    }
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func presentCutomAlertVC(target:String, title:String, message:String) {
        let nextVC = AlertMessageViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    @objc func didTapQuestionButton() {
        isQuestionButtonTapped = isQuestionButtonTapped ? false : true
    }
    
    @objc func didTapSelectMBTIView() {
        print("didTapSelectMBTIView")
        let nextVC = SelectMBTIViewController()
        nextVC.delegate = self
        nextVC.everyButtonisEnabled = true
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    @objc func didTapContentTextView() {
        view.endEditing(true)
    }
    
    
    @objc func didTapAlbumButton() {
//        setUpPHPickerVC()
        self.present(picker, animated: true)
    }
}

// 키보드가 올라올 때 view도 올라가도록
extension WriteCommunityViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.3
                           , animations: {
                
                let keyboardHeight = keyboardRectangle.height
                if self.view.frame.origin.y == 0 {
                    let bottomSpace = self.view.frame.height - (self.contentTextView.frame.origin.y + self.contentTextView.frame.height)
                    self.view.frame.origin.y += keyboardHeight - bottomSpace
                }
            })
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
}


// textView placeholder
extension WriteCommunityViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
           if contentTextView.text == textViewPlaceHolder {
               contentTextView.text = nil
               contentTextView.textColor = .black
           }
       }
    
    func textViewDidEndEditing(_ textView: UITextView) {
           if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
               contentTextView.text = textViewPlaceHolder
               contentTextView.textColor = .lightGray
//               updateCountLabel(characterCount: 0)
           }
       }
}

extension WriteCommunityViewController: AlertMessageDelegate {
    func okButtonTapped(from: String) {
        if from == "delete" {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
private extension WriteCommunityViewController {
    func layout() {
        selectMBTIViewLayout()
        
        [selectMBTIView,
         questionButton,
         titleTextField,
         lineview,
         contentTextView,
         albumButton].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        selectMBTIView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.equalTo(42.0)
//            $0.width.equalTo(264.0)
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
            $0.height.equalTo(1.0)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(lineview.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(titleTextField)
            $0.height.equalTo(300)
        }
        
        albumButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20.0)
            $0.leading.equalTo(titleTextField)
        }
    }
    
    func attribute() {
        selectMBTIView.layer.cornerRadius = 21.0
        selectMBTIView.layer.borderColor = UIColor.primary.cgColor
        selectMBTIView.layer.borderWidth = 1.0
        questionButton.setImage(UIImage(named: "Group 986375"), for: .normal)
        questionButton.addTarget(self, action: #selector(didTapQuestionButton), for: .touchUpInside)
        
        titleTextField.placeholder = "제목을 입력하세요."
        lineview.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        contentTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
        contentTextView.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
        contentTextView.text = textViewPlaceHolder
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContentTextView))
        view.addGestureRecognizer(tapGesture)
        
        albumButton.setImage(UIImage(named: "Group 986367"), for: .normal)
        albumButton.addTarget(self, action: #selector(didTapAlbumButton), for: .touchUpInside)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        
        let rightButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapCompleteButton))
        let leftButton = UIBarButtonItem(image: UIImage(named: "ic_baseline-close"), style: .done, target: self, action: #selector(didTapCloseButton))
        rightButton.tintColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        leftButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
        title = "글쓰기"
    }
    
    func selectMBTIViewLayout() {
        [selectMBTILabel,selectMBTIImage].forEach {
            self.selectMBTIView.addSubview($0)
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
        
        selectMBTILabel.text = "대상 MBTI 선택"
        selectMBTILabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        selectMBTILabel.textColor = .primary
        
        selectMBTIImage.image = UIImage(named: "header_login")
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelectMBTIView))
        self.selectMBTIView.addGestureRecognizer(gesture)
    }
    
//    func setupHeaderView() {
//
//        self.view.addSubview(headerView)
//        [headerLabel,closeButton,completeButton].forEach {
//            self.headerView.addSubview($0)
//        }
//
//        let safeArea = self.view.safeAreaLayoutGuide
//
//        headerView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(48.0)
//            $0.top.equalTo(safeArea)
//        }
//
//        headerLabel.snp.makeConstraints {
//            $0.centerX.centerY.equalTo(headerView)
//        }
//
//        closeButton.snp.makeConstraints {
//            $0.centerY.equalTo(headerLabel)
//            $0.leading.equalToSuperview().inset(20.0)
//            $0.width.height.equalTo(24.0)
//        }
//
//        completeButton.snp.makeConstraints {
//            $0.centerY.equalTo(headerLabel)
//            $0.trailing.equalToSuperview().inset(20.0)
//        }
//
//        headerLabel.text = "글쓰기"
//        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
//        headerLabel.textColor = .blackTextColor
//        headerLabel.textAlignment = .center
//
//        closeButton.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
//        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
//
//        completeButton.setTitle("완료", for: .normal)
//        completeButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
//        completeButton.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0), for: .normal)
//        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
//    }
}
