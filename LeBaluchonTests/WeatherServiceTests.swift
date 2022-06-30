//
//  WeatherServiceTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 28/06/2022.
//

import XCTest
@testable import LeBaluchon

class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    
    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
    }
    // MARK: - fetchConversionRates
    
    func testGivenFailingNetwork_WhenFetchCity_ThenGetFailure() throws {
        let failureNetworkServiceMock = WeatherNetworkServiceMock(result: .failure(.failedToFetch))
        let weatherService = WeatherService(networkService: failureNetworkServiceMock)
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        weatherService.didProduceError = { error in
            XCTAssertEqual(error, WeatherServiceError.failedToFetchCityWeather)
            expectation.fulfill()
        }
        
        weatherService.fetchCitiesInformation()
        wait(for: [expectation], timeout: 0.1)
    }
    
//    func testGivenValidNetwork_WhenFetchCity_ThenGetSuccess() throws {
//        let failureNetworkServiceMock = WeatherNetworkServiceMock(result: .success(<#T##WeatherCityResponse#>))
//        let weatherService = WeatherService(networkService: failureNetworkServiceMock)
//        
//        let expectation = XCTestExpectation(description: "Wait for completion")
//        
//        weatherService.isLoadingDidChange = { [weak self] isLoading in
//            if isLoading {
//                XCTAssertEqual(is)
//                expectation.fulfill()
//            }
//        }
//        
//        weatherService.fetchCitiesInformation()
//        wait(for: [expectation], timeout: 0.1)
//    }
    
    
    func testGivenFailingUrl_WhenFetchCity_ThenGetFailure() throws {
        let weatherUrlProviderMock = WeatherUrlProviderMock()
        let weatherService = WeatherService(weatherUrlProvider: weatherUrlProviderMock)
        
        
        let expectation = XCTestExpectation(description: "Wait for completion")
//
//        weatherService.fetchCitiesInformation { result in
//            switch result {
//            case .failure(let error):
//                XCTAssertEqual(error, WeatherServiceError.failedToFetchCityWeather)
//            case .success:
//                XCTFail("Should not be successful")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.1)
    }
    
//    func testGivenValidNetwork_WhenFetchCity_ThenGetSuccess() throws {
//        // let mockResponse =
//
//        let networkServiceMock = WeatherNetworkServiceMock(result: .success(mockResponse))
//        let weatherService = WeatherService(networkService: networkServiceMock)
//
//        let expectation = XCTestExpectation(description: "Wait for completion")
//
//        weatherService.fetchCitiesInformation { result in
//            switch result {
//            case .failure:
//                XCTFail("Should be succesful")
//
//            case .success:
//                XCTAssertTrue(true)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.1)
//    }
    
    // MARK: - add(city: WeatherCitySelection)
    
    func testGivenSelectedCitiesIsEmpty_WhenAddCity_ThenCityAddedToSelectedCities() {
        weatherService.selectedCities = []
        
        weatherService.add(city: .newYork)
        
        XCTAssertEqual(weatherService.selectedCities, [.newYork])
    }
    
    func testGivenSelectedCitiesContainsParis_WhenAddParis_ThenErrorOccured() {
        weatherService.selectedCities = [.paris]
        
        weatherService.add(city: .paris)
        
        weatherService.didProduceError = { error in
            XCTAssertEqual(error, WeatherServiceError.failedToAddNewCityAlreadyThere)
        }
    }
    
    // MARK: - removeCity(cityIndex: Int)
    
    func testGivenSelectedCitiesContainsACity_WhenRemomveCity_ThenCityIsRemovedFromSelectedCities() {
        weatherService.selectedCities = [.newYork]
        
        weatherService.removeCity(cityIndex: 0)
        
        XCTAssertTrue(weatherService.selectedCities.isEmpty)
    }
    
    // MARK: - emptySourceText
    
    func testGivenSourceTextIsNotEmpty_WhenDeleteSourceTextContent_ThenSourceTextIsEmpty() {
        weatherService.searchText = "I am not empty"
        weatherService.emptySearchText()
        
        XCTAssertEqual(weatherService.searchText, "")
    }
}
