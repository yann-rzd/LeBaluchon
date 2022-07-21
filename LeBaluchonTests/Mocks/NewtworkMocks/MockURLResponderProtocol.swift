//
//  MockURLResponderProtocol.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 21/07/2022.
//

import Foundation

protocol MockURLResponderProtocol {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder
}
