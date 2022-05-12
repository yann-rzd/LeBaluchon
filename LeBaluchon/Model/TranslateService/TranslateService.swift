//
//  TranslateService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation

import Combine



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

enum TranslateServiceError: Error {
    case failedToFetchTranslation
}

enum LanguageSelectionType {
    case source
    case target
    
    
    var navigationTitle: String {
        switch self {
        case .source:
            return "Select Source"
        case .target:
            return "Select Target"
        }
    }
}

final class TranslateService {
    
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
    
    
    func fetchTranslation(
        completionHandler: @escaping (Result<Void, TranslateServiceError>) -> Void
    ) {
       
        guard let url = getFetchTranslationUrl() else {
            completionHandler(.failure(.failedToFetchTranslation))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let body = TranslationRequestBody(
            q: [sourceText],
            target: targetLanguage.rawValue
        )
        
        guard let encoddedBody = try? JSONEncoder().encode(body) else {
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

    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
    }
    
    
    private(set) var targetText = "" {
        didSet {
            onTargetTextChanged?(targetText)
        }
    }
    
    
    private let apiKey = ""
    

    private let networkService: NetworkServiceProtocol
    
    private let languages: [Language] = Language.allCases
    
    
    private func getFilteredLanguages(searchText: String) -> [Language] {
        guard !searchText.isEmpty else {
            return languages
        }
        
        return languages.filter { language in
            language.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    
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



struct TranslationRequestBody: Encodable {
    init(q: [String], target: String) {
        self.q = q
        self.target = target
    }
    
 
    
    let q: [String]
    let target: String
}
