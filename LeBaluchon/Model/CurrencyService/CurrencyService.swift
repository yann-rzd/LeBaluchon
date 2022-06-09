//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation

final class CurrencyService: CurencyServiceProtocol {
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
    }
    
    
    //MARK: -INTERNAL: propteries
    
    static let shared = CurrencyService()
    
    var onValueToConvertChanged: ((Int?) -> Void)?
    var onConvertedValueChanged: ((Double?) -> Void)?
    var onSourceCurrencyChanged: ((Currency) -> Void)?
    var onTargetCurrencyChanged: ((Currency) -> Void)?
    var onSearchResultChanged: (() -> Void)?
    
    var valueToConvert: Int? = 1 {
        didSet {
            onValueToConvertChanged?(valueToConvert)
            if let valueToConvert = valueToConvert {
                convertValue()
            } else {
                convertedValue = nil
            }
        }
    }
    
    var convertedValue: Double? {
        didSet {
            onConvertedValueChanged?(convertedValue)

        }
    }
    
    var sourceCurrency: Currency = .EUR {
        didSet {
            print("6. JAPELLE LE BLOCK DE CODE QUI A ETE ASSIGNER POUR ECOUTER LES CHANGEMENTS SUR SOURCE CURRENCY")
            onSourceCurrencyChanged?(sourceCurrency)
            convertValue()
        }
    }
    
    var targetCurrency: Currency = .USD {
        didSet {
            print("6. JAPELLE LE BLOCK DE CODE QUI A ETE ASSIGNER POUR ECOUTER LES CHANGEMENTS SUR TARGET CURRENCY")
            onTargetCurrencyChanged?(targetCurrency)
            convertValue()
        }
    }
    
    var currencySelectionType: CurrencySelectionType?
    
    var searchText = "" {
        didSet {
            filteredCurrencies = getFilteredCurrencies(searchText: searchText)
        }
    }
    
   lazy var filteredCurrencies: [Currency] = currencies {
        didSet {
            onSearchResultChanged?()
        }
    }
    
    
    // MARK: - INTERNAL: methods
 
    func swapCurrencies() {
        let tempSourceCurrency = sourceCurrency
        sourceCurrency = targetCurrency
        targetCurrency = tempSourceCurrency
    }
    
    func assignCurrency(currency: Currency) {
        print("4. JASSIGNE LA DEVISE SELECTIONNER SELON LE TYPE DE SELECTION FAIT A LETAPE 1")
        switch currencySelectionType {
        case .target:
            print("5. JASSIGNE A LA TARGET")
            targetCurrency = currency
        case .source:
            print("5. JASSIGNE A LA SOURCE")
            sourceCurrency = currency
        case .none:
            break
        }
    }
    
    func fetchConversionRates(completionHandler: @escaping (Result<Void, CurrencyServiceError>) -> Void) {
       
        guard let url = getRatesUrl() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<FixerLatestResponse, NetworkServiceError>) in
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchConversionRate))
                print("Erreur lors de la récupération des taux de conversion")
                return
            case .success(let ratesResponse):
                let rates = ratesResponse.rates
                self?.rates = rates
                completionHandler(.success(()))
                print(ratesResponse)
                return
                
            }
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let networkService: NetworkServiceProtocol
    
    private let currencies: [Currency] = Currency.allCases
    
    private var sourceRate: Double? {
        guard let rates = rates else { return nil }
        return rates[sourceCurrency.rawValue]
    }
    
    
    private var targetRate: Double? {
        guard let rates = rates else { return nil }
        return rates[targetCurrency.rawValue]
    }
    
    private var conversionRate: Double? {
        guard let sourceRate = sourceRate,
              let targetRate = targetRate
        else {
            return nil
        }
    
        // SOURCE CHF 1.1 / EUR 1.0
        // TARGET USD 1.5 / EUR 1.0
        
        // (1.5 / 1.0) * (1.0 / 1.2) => 1.5 / 1.2
        
        return targetRate / sourceRate

    }
    
    private var rates: [String: Double]?
    
    
    // MARK: - PRIVATE: methods
    
    private func getFilteredCurrencies(searchText: String) -> [Currency] {
        guard !searchText.isEmpty else {
            return currencies
        }
        
        return currencies.filter { currency in
            currency.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    private func getRatesUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/api/latest"
        urlComponents.queryItems = [
            .init(name: "access_key", value: "3a76b9ba8ccd1e783d8b18001496f9fa")
        ]
        
        return urlComponents.url
    }
    
    
    private func convertValue() {
        guard let conversionRate = conversionRate,
              let valueToConvert = valueToConvert
        else {
            return
        }
        
        self.convertedValue =  Double(valueToConvert) * conversionRate
    }
}
