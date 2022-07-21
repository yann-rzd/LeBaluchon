//
//  CurrencyUrlProviderMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 23/06/2022.
//

import Foundation
@testable import LeBaluchon

final class CurrencyUrlProviderMock: CurrencyUrlProviderProtocol {
    func getRatesUrl() -> URL? {
        return nil
    }
}
