//
//  LeBaluchonTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import XCTest
@testable import LeBaluchon

class CurrencyServiceTests: XCTestCase {
    
    var currencyService: CurrencyService!
    
    override func setUp() {
        super.setUp()
        currencyService = CurrencyService()
    }
    
    // MARK: - fetchConversionRates
    
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
    
    // MARK: - swapCurrencies
    
    func testGivenSourceAndTargetCurrency_WhenSwapCurrencies_ThenCurrenciesSwiped() {
        currencyService.sourceCurrency = .EUR
        currencyService.targetCurrency = .USD
        
        currencyService.swapCurrencies()
        
        XCTAssertEqual(currencyService.sourceCurrency, .USD)
        XCTAssertEqual(currencyService.targetCurrency, .EUR)
    }
    
    // MARK: - assignCurrency
    
    func testGivenTargetCurrencyNotAssigned_WhenAssignCurrencyToTarget_ThenTargetHasCurrencyAssigned() {
        currencyService.currencySelectionType = .target
        
        currencyService?.assignCurrency(currency: .JPY)
        
        XCTAssertEqual(currencyService.targetCurrency, .JPY)
    }
    
    func testGivenSourceCurrencyNotAssigned_WhenAssignCurrencyToSource_ThenSourceHasCurrencyAssigned() {
        currencyService.currencySelectionType = .source
        
        currencyService?.assignCurrency(currency: .JPY)
        
        XCTAssertEqual(currencyService.sourceCurrency, .JPY)
    }
    
    func testGivenNoCurrencyAssigned_WhenAssignCurrencyToNone_ThenBreak() {
        currencyService.currencySelectionType = .none
        
        currencyService?.assignCurrency(currency: .JPY)
        
        XCTAssertEqual(currencyService.sourceCurrency, .EUR)
        XCTAssertEqual(currencyService.targetCurrency, .USD)
    }
    
    // MARK: - emptySourceText
    
    func testGivenSearchTextIsNotEmpty_WhenDeleteSearchTextContent_ThenSourceTextIsEmpty() {
        currencyService.searchText = "I am not empty"
        currencyService.emptySourceText()
        
        XCTAssertEqual(currencyService.searchText, "")
    }

    // MARK: - emptySourceText
    
    func testGivenSourceAndTargetCurrencyAssigned_WhenChangeAmount_ThenTargetValueIsConverted() {
        currencyService.valueToConvert = 0
        
        XCTAssertEqual(currencyService.convertedValue, nil)
    }
    
    func testGivenSourceAndTargetCurrencyAssigned_WhenDoingNothing_ThenValueIsNotConverted() {
        currencyService.valueToConvert = nil
        
        XCTAssertEqual(currencyService.convertedValue, nil)
    }
}

