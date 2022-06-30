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
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        urlSessionConfiguration.protocolClasses = [MockUrlProtocol.self]
        let urlSessionMock = URLSession(configuration: urlSessionConfiguration)
        URLProtocol.registerClass(MockUrlProtocol.self)
        let networkSerice = NetworkService()
        
        
        let url = try XCTUnwrap( URL(string: "www.google.com"))
        let urlRequest = URLRequest(url: url)
        
        
        let expectation = XCTestExpectation(description: "Wait for completion")
        
        networkSerice.fetch(
            urlRequest: urlRequest
        ) { (result: Result<MockCodable, NetworkServiceError> ) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetch)
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


class MockUrlProtocol: URLProtocol {
    
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
            
            let data = try JSONEncoder().encode(MockCodable())
            
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))
            
            client.urlProtocol(self,
                               didReceive: response,
                               cacheStoragePolicy: .notAllowed
            )
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}
