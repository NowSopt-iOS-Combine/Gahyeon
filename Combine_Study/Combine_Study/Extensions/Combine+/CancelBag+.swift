//
//  CancelBag+.swift
//  Combine_Study
//
//  Created by Gahyun Kim on 2024/05/09.
//

import Foundation
import Combine

class CancelBag {
    var subscriptions = Set<AnyCancellable>()  // 구독된 AnyCancellable 객체들을 저장하는 Set
    
    // 모든 구독을 취소하고 subscriptions를 비운다. 이 메서드는 CancelBag 인스턴스가 더 이상 필요하지 않을 때 호출하여 메모리 누수를 방지
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    init() { }
}

extension AnyCancellable {
    // AnyCancellable 객체를 CancelBag의 subscriptions 집합에 추가
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
