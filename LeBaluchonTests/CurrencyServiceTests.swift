//
//  LeBaluchonTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import XCTest
@testable import LeBaluchon

class CurrencyServiceTests: XCTestCase {
    
    
    // MARK: fetchConversionRates
    
    func test_givenFailingNetwork_whenFetchRates_thenGetFailure() throws {
        let failureNetworkServiceMock = NetworkServiceMock(result: .failure(.failedToFetch))
        let currencyService = CurrencyService(networkService: failureNetworkServiceMock)
        
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        currencyService.fetchConversionRates { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchConversionRate)
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    
    func test_givenFailingUrl_whenFetchRates_thenGetFailure() throws {
        let currencyUrlProviderMock = CurrencyUrlProviderMock()
        let currencyService = CurrencyService(currencyUrlProvider: currencyUrlProviderMock)
        
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        currencyService.fetchConversionRates { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchConversionRate)
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    
    
    
    
    func test_givenValidNetwork_whenFetchRates_thenGetSuccess() throws {
        let mockResponse = FixerLatestResponse(
            success: true,
            timestamp: 120321,
            base: "EUR",
            date: "04/03/2022",
            rates: ["USD": 1.25]
        )
        
        let networkServiceMock = NetworkServiceMock(result: .success(mockResponse))
        
        let currencyService = CurrencyService(networkService: networkServiceMock)
        
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        currencyService.fetchConversionRates { result in
            switch result {
            case .failure:
                XCTFail("Should be succesful")
                
            case .success:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    
    
}





final class NetworkServiceMock: NetworkServiceProtocol {
    
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


