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
    
    func testGivenFailureUrl_WhenFetchCity_ThenFailedToFetchCityWeather() {
        let failureUrlProviderMock = WeatherUrlProviderMock()
        let weatherService = WeatherService(weatherUrlProvider: failureUrlProviderMock)
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        weatherService.didProduceError = { error in
            XCTAssertEqual(error, WeatherServiceError.failedToFetchCityWeather)
            expectation.fulfill()
        }
        
        weatherService.fetchCitiesInformation()
        wait(for: [expectation], timeout: 0.1)
        
        
        
        
        
        
    }
    
    func testGivenValidNetworkWithNewYorkSelectedCity_WhenFetchCityAndFinishLoading_ThenGetSuccessfullyNewYorkData() throws {
        let mockRepsonse = WeatherCityResponse.initWithDefaultValues()
        
        let failureNetworkServiceMock = WeatherNetworkServiceMock(result: .success(mockRepsonse))
        let weatherService = WeatherService(networkService: failureNetworkServiceMock)

        let expectation = XCTestExpectation(description: "Wait for completion")

        weatherService.isLoadingDidChange = { [weak self] isLoading in
            if !isLoading {
                let newYorkCityData = try!  XCTUnwrap(weatherService.weatherCities[.newYork])
                XCTAssertEqual(newYorkCityData.temparatureMin, 1)
                expectation.fulfill()
            }
        }

        weatherService.fetchCitiesInformation()
        wait(for: [expectation], timeout: 0.1)
    }
    
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
