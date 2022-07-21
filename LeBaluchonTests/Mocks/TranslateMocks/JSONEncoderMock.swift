//
//  JSONEncoderMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 28/06/2022.
//

import Foundation
@testable import LeBaluchon

final class JSONEncoderMock: JSONEncoderProtocol {
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        throw MockError.mockError
    }
}
