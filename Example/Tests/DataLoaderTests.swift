//
//  DataLoaderTests.swift
//  Downloader_Tests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Downloader

class DataLoaderTests: XCTestCase {
    var loader: DataLoader!
    var session: URLSession!
    var cache: LRUCache<URL, Data>!
    var queue: OperationQueue!

    override func setUp() {
        super.setUp()
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
        cache = LRUCache<URL, Data>(2)

        loader = DataLoader(session: session, cache: cache, queue: queue)
    }

    func testFetchSuccess() {
        let promise = expectation(description: "Waiting for fetch")
        loader.fetch(URLProtocolMock.mockUrl) { result in
            switch result {
            case let .success(data):
                let value = String(data: data, encoding: .utf8)
                XCTAssertEqual(value, "1")
            default:
                XCTFail("Can't fetch the expected data")
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testMultipleRequestsWithCancel() {
        let promise = expectation(description: "Waiting for fetch")

        XCTAssertEqual(queue.operationCount, 0)

        loader.fetch(URLProtocolMock.mockUrl) { _ in

        }

        loader.fetch(URLProtocolMock.mockUrl) { _ in

        }?.cancel()

        loader.fetch(URLProtocolMock.mockUrl) { _ in

        }

        XCTAssertEqual(queue.operationCount, 1)


        loader.fetch(URLProtocolMock.mockUrl) { result in
            switch result {
            case let .success(data):
                let value = String(data: data, encoding: .utf8)
                XCTAssertEqual(value, "1")
            default:
                XCTFail("Can't fetch the expected data")
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchFail() {
        let promise = expectation(description: "Waiting for fetch")
        loader.fetch(URL(string: "http://blablabla.com/")!) { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error, NetworkError.notFound)
            default:
                XCTFail("Request should return an error!")
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

}
