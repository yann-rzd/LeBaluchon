//
//  TranslationRequestBodyMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 28/06/2022.
//

import Foundation
@testable import LeBaluchon

struct TranslationRequestBodyMock {
    
    init(q: [String], target: String) {
        self.q = q
        self.target = target
    }
    
    let q: [String]
    let target: String
}
