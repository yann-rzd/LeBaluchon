//
//  TranslationRequestBody.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

struct TranslationRequestBody: Encodable {
    init(q: [String], target: String) {
        self.q = q
        self.target = target
    }
    
    let q: [String]
    let target: String
}
