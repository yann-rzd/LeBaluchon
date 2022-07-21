//
//  FakeContainerResponder.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 21/07/2022.
//

import Foundation

struct FakeContainerResponder {
    let data: Data?
    let statusCode: Int
    let error: MockError?
}
