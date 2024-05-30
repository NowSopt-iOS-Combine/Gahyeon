//
//  NicknameViewModel.swift
//  Combine_Study
//
//  Created by Gahyun Kim on 2024/05/30.
//

import UIKit

import Combine

final class NicknameViewModel {
    
    // nickname 값을 저장할 변수 -> 값의 변화를 감지하고 이벤트를 발산하기 위해 @Published로 생성
//    @Published var nicknameInput: String = "" {
//        didSet {
//            print("MyViewModel / nicknameInput: \(nicknameInput)")
//        }
//    }
    
    
    // Input
    let nicknameText = PassthroughSubject<String, Never>()
    
    // Output
    @Published var isSaveButtonEnabled: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        nicknameText
            .map { !$0.isEmpty }
            .assign(to: &$isSaveButtonEnabled)
    }
    
}
