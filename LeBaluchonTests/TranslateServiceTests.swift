//
//  TranslateServiceTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 27/06/2022.
//

import XCTest
@testable import LeBaluchon

class TranslateServiceTests: XCTestCase {
    
    var translateService: TranslateService!
    
    override func setUp() {
        super.setUp()
        translateService = TranslateService()
    }
    
    //MARK: - fetchTranslation
    
    func testGivenFailingNetwork_WhenFetchTranslation_ThenGetFailure() throws {
        let failureNetworkServiceMock = TranslateNetworkServiceMock(result: .failure(.failedToFetch))
        let translateService = TranslateService(networkService: failureNetworkServiceMock)
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        translateService.fetchTranslation { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchTranslation)
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenFailingUrl_WhenFetchTranslation_ThenGetFailure() throws {
        let translateUrlProviderMock = TranslateUrlProviderMock()
        let translateService = TranslateService(translateUrlProvider: translateUrlProviderMock)
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        translateService.fetchTranslation { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchTranslation)
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenValidNetwork_WhenFetchTranslation_ThenGetSuccess() throws {
        let translatedTexts = TranslatedTextContainer(
            translatedText: "Hello day",
            detectedSourceLanguage: "fr")
        
        let translation = TranslationContainer(translations: [translatedTexts])
        
        let mockResponse = TranslationResponse(data: translation)
        
        let networkServiceMock = TranslateNetworkServiceMock(result: .success(mockResponse))
        let translateService = TranslateService(networkService: networkServiceMock)
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        translateService.fetchTranslation { result in
            switch result {
            case .failure(let error):
                XCTFail("Should be succesful")
            case .success:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}


