//
//  TranslateNetworkServiceMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 27/06/2022.
//

import Foundation
@testable import LeBaluchon

final class TranslateNetworkServiceMock: NetworkServiceProtocol {
    
    init(
        result: Result<TranslationResponse, NetworkServiceError>
    ) {
        self.result = result
    }
    
    private let result: Result<TranslationResponse, NetworkServiceError>
    
    func fetch<T>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable {
        
        completionHandler(result as! Result<T, NetworkServiceError>)
    }
}
