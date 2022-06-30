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
    
    func testGivenFailingBody_WhenFetchTranslation_ThenGetFailure() throws {
        let JSONEncoder =  JSONEncoderMock()
        let translateService = TranslateService(jsonEncoder: JSONEncoder)
        
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
    
    func testGivenValidNetworkButReturningEmptyTranslations_WhenFetchTranslation_ThenGetFailure() throws {
        
        let translation = TranslationContainer(translations: [])
        
        let mockResponse = TranslationResponse(data: translation)
        
        let networkServiceMock = TranslateNetworkServiceMock(result: .success(mockResponse))
        let translateService = TranslateService(networkService: networkServiceMock)
        
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
    
//    func testGivenFailureTranslationResponse_WhenFetchTranslation_ThenGetFailure() throws {
//        let mockResponse = TranslationResponseMock(data: nil)
//        
//        let networkServiceMock = TranslateNetworkServiceFailureResponseMock(result: .success(mockResponse))
//        let translateService = TranslateService(networkService: networkServiceMock)
//        
//        let expectation = XCTestExpectation(description: "Wait for completion")
//        
//        translateService.fetchTranslation { result in
//            switch result {
//            case .failure:
//                XCTFail("Should be succesful")
//            case .success(let error):
//                XCTAssertTrue(true)
//                XCTAssertEqual(error, .failedToFetchTranslation)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.1)
//    }
    
    //MARK: - assignLanguage
    
    func testGivenTargetLanguageNotAssigned_WhenAssignLanguageToTarget_ThenTargetHasLanguageAssigned() {
        translateService.languageSelectionType = .target
        translateService.assignLanguage(language: .it)
        XCTAssertEqual(translateService.targetLanguage, .it)
    }
    
    func testGivenSourceLanguageNotAssigned_WhenAssignLanguageToSource_ThenSourceHasLanguageAssigned() {
        translateService.languageSelectionType = .source
        translateService.assignLanguage(language: .it)
        XCTAssertEqual(translateService.sourceLanguage, .it)
    }
    
    func testGivenSourceLanguageNotAssigned_WhenAssignLanguageToNone_ThenBreak() {
        translateService.languageSelectionType = .none
        translateService.assignLanguage(language: .it)
        XCTAssertEqual(translateService.targetLanguage, .en)
        XCTAssertEqual(translateService.sourceLanguage, nil)
    }
    
    // MARK: - emptySourceText
    
    func testGivenSourceTextIsNotEmpty_WhenDeleteSourceTextContent_ThenSourceTextIsEmpty() {
        translateService.sourceText = "I am not empty"
        translateService.emptySourceText()
        
        XCTAssertEqual(translateService.sourceText, "")
    }
    
    // MARK: - emptySearchText
    
    func testGivenSearchTextIsNotEmpty_WhenDeleteSearchTextContent_ThenSearchTextIsEmpty() {
        translateService.searchText = "I am not empty"
        translateService.emptySearchText()
        
        XCTAssertEqual(translateService.searchText, "")
    }
    
    // MARK: - setup
    
    func testGivenSourceLanguageTranslated_WhenSetup_ThenDefaultConfiguration() {
        translateService.sourceLanguage = .it
        translateService.targetLanguage = .ja
        translateService.isLoading = true
        
        translateService.setup()
        
        XCTAssertEqual(translateService.sourceLanguage, nil)
        XCTAssertEqual(translateService.targetLanguage, .en)
        XCTAssertEqual(translateService.isLoading, false)
    }
}


