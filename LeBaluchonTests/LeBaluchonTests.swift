//
//  LeBaluchonTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import XCTest
@testable import LeBaluchon

class LeBaluchonTests: XCTestCase {
    
    func testExampleFailure() throws {
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
    
    
    
    
    
    func testExampleSuccessful() throws {
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
                
            case .success(let rates):
                XCTAssertTrue(true)
                XCTAssertEqual(rates["USD"], 1.25)
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


