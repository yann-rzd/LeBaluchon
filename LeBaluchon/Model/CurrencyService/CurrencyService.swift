//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation

final class CurrencyService: CurencyServiceProtocol {
    func fetchConversionRates() {
       
        guard let url = getRatesUrl() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        
        networkService.fetch(urlRequest: urlRequest) { (result: Result<FixerLatestResponse, NetworkServiceError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let ratesResponse):
                print(ratesResponse)
            }
        }
    }
    
    
    static let shared = CurrencyService()
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
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
    
    private let networkService: NetworkServiceProtocol
}
