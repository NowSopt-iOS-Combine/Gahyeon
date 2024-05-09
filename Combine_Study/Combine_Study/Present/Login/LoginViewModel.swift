//
//  LoginViewModel.swift
//  Combine_Study
//
//  Created by Gahyun Kim on 2024/05/09.
//

import Foundation

import Combine

final class LoginViewModel {
    
    // 사용자 아이디와 비밀번호의 값을 저장할 변수 -> 값의 변화를 감지하고 이벤트를 발산하기 위해 @Published로 생성
    @Published var usrIDInput: String = "" {
        didSet {
            print("MyViewModel / IDInput: \(usrIDInput)")
        }
    }
    
    @Published var usrPasswordInput: String = "" {
        didSet {
            print("MyViewModel / passwordInput: \(usrPasswordInput)")
        }
    }
    
    // 두 개의 텍스트 필드가 모두 입력 되었을때 값을 전달하도록 하는 publisher를 생성
    // usrIDInput, usrPasswordInput가 모두 초기화된 이후에 사용할 수 있도록 lazy 키워드로 지연 연산
    lazy var isFilled: AnyPublisher<Bool, Never> = Publishers.CombineLatest($usrIDInput, $usrPasswordInput)
        .map{
            if $0 == "" || $1 == "" {  // ID, Password 둘 다 비어있으면
                return false
            } else {
                return true
            }
        }
        .print()
        .eraseToAnyPublisher()
}
