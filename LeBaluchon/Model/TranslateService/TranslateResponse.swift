//
//  TranslateResponse.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

struct TranslationResponse: Codable {
    let data: TranslationContainer
}

struct TranslationContainer: Codable {
    let translations: [TranslatedTextContainer]
}

struct TranslatedTextContainer: Codable {
    let translatedText: String
    let detectedSourceLanguage: String
}
