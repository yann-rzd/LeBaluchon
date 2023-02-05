//
//  TranslateUrlProvider.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 22/07/2022.
//

import Foundation

protocol TranslateUrlProviderProtocol {
    func getFetchTranslationUrl() -> URL?
}

final class TranslateUrlProvider: TranslateUrlProviderProtocol {
    static let shared = TranslateUrlProvider()
    
    func getFetchTranslationUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            .init(name: "key", value: APIKeys.translationKey)
        ]
        
        return urlComponents.url
    }
}
