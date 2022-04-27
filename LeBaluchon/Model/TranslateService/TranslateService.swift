//
//  TranslateService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation

import Combine



struct TranslationResponse: Codable {
    let translatedText: String
}

enum TranslateServiceError: Error {
    case failedToFetchTranslation
}

enum LanguageSelectionType {
    case source
    case target
}

final class TranslateService {
    
    static let shared = TranslateService()
    
    var onSourceLanguageChanged: ((Language) -> Void)?
    var onTargetLanguageChanged: ((Language) -> Void)?
    
    var onSourceTextChanged: ((String) -> Void)?
    var onTargetTextChanged: ((String) -> Void)?
    
    var onSearchResultChanged: (() -> Void)?
    
    let languages: [Language] = Language.allCases
    
    var languageSelectionType: LanguageSelectionType?
    
    var sourceLanguage: Language = .fr {
        didSet {
            onSourceLanguageChanged?(sourceLanguage)
        }
    }
    
    
    var targetLanguage: Language = .en {
        didSet {
            onTargetLanguageChanged?(targetLanguage)
        }
    }
    
    
    var sourceText = "" {
        didSet {
            print(sourceText)
            onSourceTextChanged?(sourceText)
        }
    }
    
    private(set) var targetText = "" {
        didSet {
            onTargetTextChanged?(targetText)
        }
    }
    
    
    func swapLanguages() {
        let tempSourceLanguage = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = tempSourceLanguage
    }
    
    func assignLanguage(language: Language) {
        switch languageSelectionType {
        case .target:
            targetLanguage = language
        case .source:
            sourceLanguage = language
        case .none:
            break
        }
    }
    
    
    
    func emptySourceText() {
        sourceText.removeAll()
    }
    
    
    private let apiKey = ""
    
    
    
    func fetchTranslation(
        for text: String,
        source: Language,
        target: Language,
        completionHandler: @escaping (Result<Void, TranslateServiceError>) -> Void
    ) {
       
        guard let url = getFetchTranslationUrl() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<TranslationResponse, NetworkServiceError>) in
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchTranslation))
                print("Erreur lors de la récupération de la traduction")
                return
            case .success(let translationResponse):
                return
                
            }
        }
    }
    
    
    
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
    }
    
    
    
    
    private let networkService: NetworkServiceProtocol
    
    
    
    
    private func getFetchTranslationUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            .init(name: "key", value: apiKey)
        ]
        
        return urlComponents.url
    }
    
    
}
