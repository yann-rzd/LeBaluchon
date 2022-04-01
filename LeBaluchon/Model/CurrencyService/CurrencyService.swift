//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation


enum CurrencyServiceError: Error {
    case failedToFetchConversionRate
    
    
}

final class CurrencyService: CurencyServiceProtocol {
    
    static let shared = CurrencyService()
 
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
    }
    
    
    
    func fetchConversionRates(completionHandler: @escaping (Result<[String: Double], CurrencyServiceError>) -> Void) {
       
        guard let url = getRatesUrl(path: "api/latest") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        networkService.fetch(urlRequest: urlRequest) { (result: Result<FixerLatestResponse, NetworkServiceError>) in
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchConversionRate))
                print("Erreur lors de la récupération des taux de conversion")
                return
            case .success(let ratesResponse):
                let rates = ratesResponse.rates
                completionHandler(.success(rates))
                print(ratesResponse)
                return
                
            }
        }
    }
    
    func fetchRatesSymnols(completionHandler: @escaping (Result<[String: Double], CurrencyServiceError>) -> Void) {
       
        guard let url = getRatesUrl(path: "api/symbols") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        networkService.fetch(urlRequest: urlRequest) { (result: Result<FixerLatestResponse, NetworkServiceError>) in
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchConversionRate))
                print("Erreur lors de la récupération des taux de conversion")
                return
            case .success(let ratesResponse):
                let rates = ratesResponse.rates
                completionHandler(.success(rates))
                print(ratesResponse)
                return
                
            }
        }
    }
    
    private func getRatesUrl(path: String) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = path
        urlComponents.queryItems = [
            .init(name: "access_key", value: "3a76b9ba8ccd1e783d8b18001496f9fa")
        ]
        
        return urlComponents.url
    }
    
    
    private let networkService: NetworkServiceProtocol
}
