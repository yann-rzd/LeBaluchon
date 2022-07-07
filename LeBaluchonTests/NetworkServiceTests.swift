//
//  NetworkServiceTests.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 30/06/2022.
//

import XCTest
@testable import LeBaluchon

class NetworkServiceTests: XCTestCase {

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
            case .failure(let error):
                XCTFail("Should not be successful")
            case .success:
                XCTAssertTrue(true)
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
}


struct MockCodable: Codable {

}



protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder
}



struct FakeContainerResponder {
    let data: Data?
    let statusCode: Int
    let error: MockError?
}

class DataSuccessNoErrorResponder: MockURLResponder {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder {
        let data = try JSONEncoder().encode(MockCodable())
        return .init(
            data: data,
            statusCode: 200,
            error: nil
        )
    }
}


class NoDataSuccessNoErrorResponder: MockURLResponder {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder {
        return .init(
            data: nil,
            statusCode: 200,
            error: nil
        )
    }
}


class DataFailureNoErrorResponder: MockURLResponder {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder {
        let data = try JSONEncoder().encode(MockCodable())
        return .init(
            data: data,
            statusCode: 400,
            error: nil
        )
    }
}


class DataSuccessWithErrorResponder: MockURLResponder {
    static func respond(to request: URLRequest) throws -> FakeContainerResponder {
        let data = try JSONEncoder().encode(MockCodable())
        return .init(
            data: data,
            statusCode: 200,
            error: MockError.mockError
        )
    }
}



class MockUrlProtocol<Responder: MockURLResponder>: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }


    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }


    override func startLoading() {
        guard let client = client else { return }

        do {
            // Here we try to get data from our responder type, and
            // we then send that data, as well as a HTTP response,
            // to our client. If any of those operations fail,
            // we send an error instead:
            //let data = try Responder.respond(to: request)

            //let data = try JSONEncoder().encode(MockCodable())
            
             

            let fakeContainerResponder = try Responder.respond(to: request)
            
            guard fakeContainerResponder.error == nil else {
                throw fakeContainerResponder.error ?? MockError.mockError
            }
            
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(request.url),
                statusCode: fakeContainerResponder.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))

            client.urlProtocol(self,
                               didReceive: response,
                               cacheStoragePolicy: .notAllowed
            )
            
            guard let data = fakeContainerResponder.data else {
                throw MockError.mockError
                
            }
            
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {

    }

}




extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockUrlProtocol<T>.self)
    }
}



