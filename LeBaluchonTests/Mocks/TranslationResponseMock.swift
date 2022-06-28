//
//  TranslationResponseMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 28/06/2022.
//

import Foundation
@testable import LeBaluchon

struct TranslationResponseMock: Codable {
    let data: TranslationContainer?
}

struct TranslationContainerMock: Codable {
    let translations: [TranslatedTextContainer]
}

struct TranslatedTextContainerMock: Codable {
    let translatedText: String
    let detectedSourceLanguage: String
}
