//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//


import Foundation

final class CurrencyService {
    
    init(
        //networkService: NetworkServiceProtocol = NetworkService.shared,
        networkService: NetworkServiceProtocol = CurrencyNetworkServiceMock.prototype,
        currencyUrlProvider: CurrencyUrlProviderProtocol = CurrencyUrlProvider.shared
    ) {
        self.networkService = networkService
        self.currencyUrlProvider = currencyUrlProvider
    }
    
    
    //MARK: -INTERNAL: propteries
    
    static let shared = CurrencyService()
    
    var onValueToConvertChanged: ((Int?) -> Void)?
    var onConvertedValueChanged: ((Double?) -> Void)?
    var onSourceCurrencyChanged: ((Currency) -> Void)?
    var onTargetCurrencyChanged: ((Currency) -> Void)?
    var onSearchResultChanged: (() -> Void)?
    var isLoadingDidChange: ((Bool) -> Void)?
    var onSourceValueTextChanged: ((String) -> Void)?
    var onConvertedValueTextChanged: ((String) -> Void)?
    var didProduceError: ((CurrencyServiceError) -> Void)?
    
    var isLoading: Bool {
        currentDownloadCount != 0
    }
    
    var sourceValueText = "" {
        didSet {
            onSourceValueTextChanged?(sourceValueText)
        }
    }
    
    var convertedValueText = "" {
        didSet {
            onConvertedValueTextChanged?(convertedValueText)
        }
    }

    
    var valueToConvert: Int? = 1 {
        didSet {
            onValueToConvertChanged?(valueToConvert)
            if valueToConvert != nil {
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
            onSourceCurrencyChanged?(sourceCurrency)
            convertValue()
        }
    }
    
    var targetCurrency: Currency = .USD {
        didSet {
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
        switch currencySelectionType {
        case .target:
            targetCurrency = currency
        case .source:
            sourceCurrency = currency
        case .none:
            break
        }
    }
    
    func fetchConversionRates(completionHandler: @escaping (Result<Void, CurrencyServiceError>) -> Void) {
        
        guard let url = currencyUrlProvider.getRatesUrl() else {
            self.didProduceError?(.failedToFetchConversionRate)
            completionHandler(.failure(.failedToFetchConversionRate))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("p0wnUjeVTctuLS8GxvpiTgh6xDPSDoc2", forHTTPHeaderField: "apikey")
        
        currentDownloadCount += 1
        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<FixerLatestResponse, NetworkServiceError>) in
            self?.currentDownloadCount -= 1
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchConversionRate))
                self?.didProduceError?(.failedToFetchConversionRate)
                return
            case .success(let ratesResponse):
                let rates = ratesResponse.rates
                self?.rates = rates
                self?.convertValue()
                completionHandler(.success(()))
                return
            }
            
        }
    }
    
    func emptyValues() {
        sourceValueText.removeAll()
        convertedValueText.removeAll()
    }

    
    func emptySearchText() {
        searchText.removeAll()
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let networkService: NetworkServiceProtocol
    private let currencyUrlProvider: CurrencyUrlProviderProtocol
    
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
        
        // (1.5 / 1.0) * (1.0 / 1.1) => 1.5 / 1.1
        
        return targetRate / sourceRate

    }
    
    private var rates: [String: Double]?
    
    private var currentDownloadCount = 0 {
        didSet {
            isLoadingDidChange?(isLoading)
        }
    }
    
    
    // MARK: - PRIVATE: methods
    
    private func getFilteredCurrencies(searchText: String) -> [Currency] {
        guard !searchText.isEmpty else {
            return currencies
        }
        
        return currencies.filter { currency in
            currency.name.lowercased().contains(searchText.lowercased())
        }
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


