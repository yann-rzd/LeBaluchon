//
//  DataFailureNoErrorResponder.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 21/07/2022.
//

import Foundation

class DataFailureNoErrorResponder: MockURLResponderProtocol {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder {
        let data = try JSONEncoder().encode(MockCodable())
        return .init(
            data: data,
            statusCode: 400,
            error: nil
        )
    }
}
