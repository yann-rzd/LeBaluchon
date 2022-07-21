//
//  MockUrlProtocol.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 21/07/2022.
//

import XCTest
@testable import LeBaluchon

class MockUrlProtocol<Responder: MockURLResponderProtocol>: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        do {
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
