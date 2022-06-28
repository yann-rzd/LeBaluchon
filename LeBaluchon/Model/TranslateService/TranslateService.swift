//
//  TranslateService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation

import Combine

final class TranslateService {
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        translateUrlProvider: TranslateUrlProviderProtocol = TranslateUrlProvider.shared,
        jsonEncoder: JSONEncoderProtocol = JSONEncoder()
    ) {
        self.networkService = networkService
        self.translateUrlProvider = translateUrlProvider
        self.jsonEncoder = jsonEncoder
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let shared = TranslateService()
    
    var onSourceLanguageChanged: ((Language?) -> Void)?
    var onTargetLanguageChanged: ((Language) -> Void)?
    var onSourceTextChanged: ((String) -> Void)?
    var onTargetTextChanged: ((String) -> Void)?
    var onSearchResultChanged: (() -> Void)?
    var onIsLoadingChanged: ((Bool) -> Void)?
    
    var isLoading = false {
        didSet {
            onIsLoadingChanged?(isLoading)
        }
    }
    
    var languageSelectionType: LanguageSelectionType?
    
    var sourceLanguage: Language? {
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
    
    var searchText = "" {
        didSet {
            filteredLanguages = getFilteredLanguages(searchText: searchText)
        }
    }
    
    lazy var filteredLanguages: [Language] = languages {
        didSet {
            onSearchResultChanged?()
        }
    }
    
    
    // MARK: - INTERNAL: methods
    
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
    
    func emptySearchText() {
        searchText.removeAll()
    }
    
    func fetchTranslation(
        completionHandler: @escaping (Result<Void, TranslateServiceError>) -> Void) {
       
            guard let url = translateUrlProvider.getFetchTranslationUrl() else {
            completionHandler(.failure(.failedToFetchTranslation))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let body = TranslationRequestBody(
            q: [sourceText],
            target: targetLanguage.rawValue
        )
        
        guard let encoddedBody = try? jsonEncoder.encode(body) else {
            completionHandler(.failure(.failedToFetchTranslation))
            return
        }
        
        urlRequest.httpBody = encoddedBody
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("✅✅ is  Loading => SET TO TRUE ")
        isLoading = true
        
        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<TranslationResponse, NetworkServiceError>) in
            
            print("❌❌ is  Loading => SET TO FALSE ")
            self?.isLoading = false
            
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchTranslation))
                print("Erreur lors de la récupération de la traduction")
                return
            case .success(let translationResponse):
                print(translationResponse)
                
                guard let firstTranslation = translationResponse.data.translations.first else {
                    completionHandler(.failure(.failedToFetchTranslation))
                    return
                }
                
                self?.targetText = firstTranslation.translatedText
                self?.sourceLanguage = Language(rawValue: firstTranslation.detectedSourceLanguage)
                completionHandler(.success(()))
                return
                
            }
        }
    }
    
    func setup() {
        sourceLanguage = nil
        targetLanguage = .en
        isLoading = false
    }

    
    // MARK: - PRIVATE: properties
    
    private let networkService: NetworkServiceProtocol
    private let translateUrlProvider: TranslateUrlProviderProtocol
    private let jsonEncoder: JSONEncoderProtocol

    private(set) var targetText = "" {
        didSet {
            onTargetTextChanged?(targetText)
        }
    }
    
    private let languages: [Language] = Language.allCases
    
    
    // MARK: - PRIVATE: methods
    
    private func getFilteredLanguages(searchText: String) -> [Language] {
        guard !searchText.isEmpty else {
            return languages
        }
        
        return languages.filter { language in
            language.name.lowercased().contains(searchText.lowercased())
        }
    }
}

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
            .init(name: "key", value: "AIzaSyBuDzRZPMVSRwstm7sVDV8Bd86rLGeg9ZM")
        ]
        
        return urlComponents.url
    }
}



protocol JSONEncoderProtocol {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

extension JSONEncoder: JSONEncoderProtocol {
    
}



