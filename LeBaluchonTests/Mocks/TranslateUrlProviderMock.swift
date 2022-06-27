//
//  TranslateUrlProviderMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 27/06/2022.
//

import Foundation
@testable import LeBaluchon

final class TranslateUrlProviderMock: TranslateUrlProviderProtocol {
    func getFetchTranslationUrl() -> URL? {
        return nil
    }
}
