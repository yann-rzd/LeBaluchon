//
//  NetworkServiceTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 30/06/2022.
//

import XCTest
@testable import LeBaluchon

class NetworkServiceTests: XCTestCase {

    func testGivenNoDataSuccessNoErrorResponder_WhenFetching_ThenGetFailure() throws {
        let session = URLSession(mockResponder: NoDataSuccessNoErrorResponder.self)
        let networkSerice = NetworkService(urlSession: session)

        let url = try XCTUnwrap( URL(string: "www.google.com"))
        let urlRequest = URLRequest(url: url)

        let expectation = XCTestExpectation(description: "Wait for completion")

        networkSerice.fetch(
            urlRequest: urlRequest
        ) { (result: Result<MockCodable, NetworkServiceError> ) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchUnknownError)
                
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenDataSuccessWithErrorResponder_WhenFetching_ThenGetFailure() throws {
        let session = URLSession(mockResponder: DataSuccessWithErrorResponder.self)
        let networkSerice = NetworkService(urlSession: session)

        let url = try XCTUnwrap( URL(string: "www.google.com"))
        let urlRequest = URLRequest(url: url)

        let expectation = XCTestExpectation(description: "Wait for completion")

        networkSerice.fetch(
            urlRequest: urlRequest
        ) { (result: Result<MockCodable, NetworkServiceError> ) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchUnknownError)
                
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenFaillingUrlSession_WhenFetching_ThenGetFailure() throws {
        let session = URLSession(mockResponder: DataFailureNoErrorResponder.self)
        let networkSerice = NetworkService(urlSession: session)

        let url = try XCTUnwrap( URL(string: "www.google.com"))
        let urlRequest = URLRequest(url: url)

        let expectation = XCTestExpectation(description: "Wait for completion")

        networkSerice.fetch(
            urlRequest: urlRequest
        ) { (result: Result<MockCodable, NetworkServiceError> ) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchBadStatusCode)
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenDataWithWrongStructureSuccessNoErrorResponder_WhenFetching_ThenGetFailure() throws {
        let session = URLSession(mockResponder: DataSuccessNoErrorResponder.self)
        let networkSerice = NetworkService(urlSession: session)

        let url = try XCTUnwrap( URL(string: "www.google.com"))
        let urlRequest = URLRequest(url: url)

        let expectation = XCTestExpectation(description: "Wait for completion")

        networkSerice.fetch(
            urlRequest: urlRequest
        ) { (result: Result<WeatherCityResponse, NetworkServiceError> ) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchCouldNoDecode)
                
            case .success:
                XCTFail("Should not be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func testGivenSuccessfulUrlSession_WhenFetching_ThenGetSuccess() throws {
        let session = URLSession(mockResponder: DataSuccessNoErrorResponder.self)
        let networkSerice = NetworkService(urlSession: session)

        let url = try XCTUnwrap( URL(string: "www.google.com"))
        let urlRequest = URLRequest(url: url)

        let expectation = XCTestExpectation(description: "Wait for completion")

        networkSerice.fetch(
            urlRequest: urlRequest
        ) { (result: Result<MockCodable, NetworkServiceError> ) in
            switch result {
            case .failure:
                XCTFail("Should not be successful")
            case .success:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}

extension URLSession {
    convenience init<T: MockURLResponderProtocol>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockUrlProtocol<T>.self)
    }
}
