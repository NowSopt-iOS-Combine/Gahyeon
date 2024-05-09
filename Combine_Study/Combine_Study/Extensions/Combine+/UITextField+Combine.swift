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
    var publisher: AnyPublisher<String, Never> {  // 클로저로써 Publisher를 가져옴
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            // compactMap으로 UITextField 가져왔어
            .compactMap{ $0.object as? UITextField}
            // map을 통해서 Textfield의 text를 가져왕
            .map{ $0.text ?? "" }    //값이 없는 경우 빈 문자열 반환
            .print()
            .eraseToAnyPublisher() //래핑이 많이 되었기 때문에 eraseToAnuPublisher
        //eraseToAnuPublisher : 타입을 지운 상태의 AnyPublisher 인스턴스를 방출할 때 사용한다네!
    }
}
