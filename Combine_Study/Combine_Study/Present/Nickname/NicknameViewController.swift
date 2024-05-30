//
//  NicknameViewController.swift
//  Combine_Study
//
//  Created by Gahyun Kim on 2024/05/09.
//

import UIKit

import Combine
import SnapKit
import Then

protocol NickNameDelegate: AnyObject {
    func bindNickName(nickname: String)
}

final class NicknameViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: NickNameDelegate?
    private var nicknameviewModel = NicknameViewModel()
    var subscribtion = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let nicknameView = NicknameView()
    private let loginView = LoginView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddTarget()
        setDelegate()
        setPublisher()
    }
}

// MARK: - Extensions

private extension NicknameViewController {
    func setDelegate() {
        nicknameView.nicknameTextField.delegate = self
    }
    func setAddTarget() {
        nicknameView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }
    
    func setPublisher() {
        
        // nicknameTextField의 텍스트 변화를 구독하여 nicknameInput에 할당
        nicknameView.nicknameTextField.publisher
            .receive(on: RunLoop.main)
            .assign(to: \.nicknameInput, on: nicknameviewModel)
            .store(in: &subscribtion)
        
        nicknameviewModel.isFilled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: nicknameView.saveButton)
            .store(in: &subscribtion)
        
//        nicknameviewModel.$nicknameInput
//            .receive(on: RunLoop.main)
//            .sink { [weak self] nickname in
//                print(nickname)
//                self?.loginView.realtimeLabel.text = nickname
//            }
//            .store(in: &subscribtion)
    }
}

extension NicknameViewController: UITextFieldDelegate {
    // 한글만 가능하게
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let titleCharacter = string.cString(using: .utf8)
        let isBackSpace = strcmp(titleCharacter, "\\b")
        if string.hasCharacters() || isBackSpace == -92 {
            return true
        }
        return false
    }
    
    
    // textField 상태에 따라 saveButton 상태 활성화 유무
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if nicknameView.nicknameTextField.text?.count ?? 0 < 1 {
            nicknameView.saveButton.isEnabled = false
            nicknameView.saveButton.backgroundColor = .systemGray2
        } else {
            nicknameView.saveButton.isEnabled = true
            nicknameView.saveButton.backgroundColor = .red
        }
    }
}

extension NicknameViewController {
    func dataBind(_ name: String) {
        if name != "" {
            nicknameView.nicknameTextField.text = name
        }
    }
    
    @objc func saveButtonDidTap() {
        print("SAVE BUTTON TAPPED")
        if let nickname = nicknameView.nicknameTextField.text {
            delegate?.bindNickName(nickname: nickname)
            self.dismiss(animated: true)
        }
    }
}
