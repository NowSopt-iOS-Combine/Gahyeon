//
//  LoginViewController.swift
//  Combine_Study
//
//  Created by Gahyun Kim on 2024/05/09.
//

import UIKit

import Combine
import SnapKit
import Then

final class LoginViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel!
    var subscribtion = Set<AnyCancellable>()
    var name: String = ""
    
    // MARK: - UI Components
    
    private let loginView = LoginView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddTarget()
        setDelegate()
        setPublisher()
    }
}

// MARK: - Extensions

private extension LoginViewController {
    func setPublisher() {
        viewModel = LoginViewModel()
        
        //assign 메서드로 해당 publisher를 subscribe하여 전달된 값으로 viewModel의 usrIDInput, usrPasswordInput 프로퍼티의 값을 각각 변경
        loginView.idTextField.publisher
            .receive(on: RunLoop.main) // Scheduler를 RunLoop.main으로 지정
        // RunLoop.main -> 터치 이벤트, 스크롤 이벤트 등 사용자 입력을 처리할 수 있는 Scheduler
            .assign(to: \.usrIDInput, on: viewModel)
            .store(in: &subscribtion)
        
        loginView.passwordTextField.publisher
            .receive(on: RunLoop.main)
            .assign(to: \.usrPasswordInput, on: viewModel)
            .store(in: &subscribtion)
        
        viewModel.isFilled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginView.loginButton) // assign으로 값을 변경하는 path는 UIButton의 isEnalbed임. 어디에? loginButton에~
            .store(in: &subscribtion)
    }
    
    func setAddTarget() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        loginView.nicknameButton.addTarget(self, action: #selector(nicknameButtonTapped), for: .touchUpInside)
        loginView.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    func setDelegate() {
        loginView.passwordTextField.delegate = self
        loginView.idTextField.delegate = self
    }
    
    func updateLoginButtonState(isEnabled: Bool, backgroundColor: UIColor, borderColor: UIColor) {
        loginView.loginButton.isEnabled = isEnabled
        loginView.loginButton.backgroundColor = backgroundColor
        loginView.loginButton.layer.borderColor = borderColor.cgColor
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    // textField가 터치가 되면 테두리 설정
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        return true
    }
    
    // textField 터치 해제 시 테두리 해제
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = .none
        textField.layer.borderWidth = 0
    }
    
    // textField 상태에 따라 LoginButton 상태 활성화 유
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (loginView.idTextField.text?.count ?? 0 < 1) || (loginView.passwordTextField.text?.count ?? 0 < 1) {
            updateLoginButtonState(isEnabled: false, backgroundColor: .black, borderColor: .systemGray4)
        } else {
            updateLoginButtonState(isEnabled: true, backgroundColor: .black, borderColor: .clear)
        }
    }
}

extension LoginViewController {
    
    // @objc func
    @objc func loginButtonDidTap() {
        print("LOGIN BUTTON TAPPED")
        pushToWelcomeVC()
    }
    
    
    @objc func nicknameButtonTapped() {
        print("NICKNAME BUTTON TAPPED")
        presentToNicknameVC()
    }
    
    @objc func clearButtonTapped() {
        loginView.passwordTextField.text = ""
    }
    
    // loginButton Click
    func pushToWelcomeVC() {
        let welcomeViewController = WelcomeViewController()
        if name == "" {
            welcomeViewController.bindData(loginView.idTextField.text ?? "")
        } else {
            welcomeViewController.bindData(name)
        }
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
    // nicknameButton Click
    func presentToNicknameVC() {
        let nicknameViewController = NicknameViewController()
        nicknameViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = nicknameViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]   //지원할 크기 지정
            sheet.delegate = self   //크기 변하는거 감지
            sheet.prefersGrabberVisible = true  //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.preferredCornerRadius = 20
        }
        nicknameViewController.delegate = self
        nicknameViewController.dataBind(self.name)
        present(nicknameViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: NickNameDelegate {
    func bindNickName(nickname: String) {
        self.name = nickname
    }
}

