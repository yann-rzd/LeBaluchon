//
//  WeatherNetworkServiceMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 28/06/2022.
//

import Foundation
@testable import LeBaluchon

final class WeatherNetworkServiceMock: NetworkServiceProtocol {
    init(
        result: Result<WeatherCityResponse, NetworkServiceError>
    ) {
        self.result = result
    }
    
    private let result: Result<WeatherCityResponse, NetworkServiceError>
    
    func fetch<T>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable {
        
        completionHandler(result as! Result<T, NetworkServiceError>)
    }
}
