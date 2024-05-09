//
//  UITextField+.swift
//  Combine_Study
//
//  Created by Gahyun Kim on 2024/05/09.
//

import UIKit
import Combine

// 텍스트 필드의 변화를 감지하고 observer에게 값을 전달하기 위해 UITextField extension으로 publisher를 생성
extension UITextField {
    var publisher: AnyPublisher<String, Never> {  // AnyPublisher<String, Never> 타입으로 텍스트 필드에 입력된 String을 observer에게 전달
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{ $0.object as? UITextField} //NotificationCenter로 들어온 notification의 optional 타입 object 프로퍼티를 UITextField로 타입 캐스팅
        //text 프로퍼티만 가져오기
            .map{ $0.text ?? "" }    //값이 없는 경우 빈 문자열 반환
            .print()
            .eraseToAnyPublisher() // 다시 AnyPublisher 타입으로 반환
    }
}

