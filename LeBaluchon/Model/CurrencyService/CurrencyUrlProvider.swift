//
//  CurrencyUrlProvider.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 21/07/2022.
//

import Foundation

protocol CurrencyUrlProviderProtocol {
    func getRatesUrl() -> URL?
}

final class CurrencyUrlProvider: CurrencyUrlProviderProtocol {
    static let shared = CurrencyUrlProvider()
    
    func getRatesUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.apilayer.com"
        urlComponents.path = "/fixer/latest"
        urlComponents.queryItems = [
            .init(name: "from", value: "EUR"),
            .init(name: "to", value: "USD")
        ]
        
        return urlComponents.url
    }
}
