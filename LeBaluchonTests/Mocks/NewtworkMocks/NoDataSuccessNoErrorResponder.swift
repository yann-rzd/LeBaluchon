//
//  NoDataSuccessNoErrorResponder.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 21/07/2022.
//

import Foundation

class NoDataSuccessNoErrorResponder: MockURLResponderProtocol {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder {
        return .init(
            data: nil,
            statusCode: 200,
            error: nil
        )
    }
}
