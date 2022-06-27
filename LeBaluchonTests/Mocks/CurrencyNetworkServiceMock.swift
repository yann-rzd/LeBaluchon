//
//  NetworkServiceMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 24/06/2022.
//

import Foundation
@testable import LeBaluchon

final class CurrencyNetworkServiceMock: NetworkServiceProtocol {
    
    init(
        result: Result<FixerLatestResponse, NetworkServiceError>
    ) {
        self.result = result
    }
    
    private let result: Result<FixerLatestResponse, NetworkServiceError>
    
    func fetch<T>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable {
        
        completionHandler(result as! Result<T, NetworkServiceError>)
    }
}
