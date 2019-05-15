//
//  LoadOperationTests.swift
//  Downloader_Tests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Downloader

class LoadOperationTests: XCTestCase {
    var queue: OperationQueue!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
    }

    func testLoadOperation() {
        let promise = expectation(description: "Waiting for data load")

        let operation = LoadOperation(url: URL(string: "http://test.com/1")!, session: session)
        operation.handler = { result in
            switch result {
            case let .success(data):
                let value = String(data: data, encoding: .utf8)
                XCTAssertEqual(value, "1")
            default:
                XCTFail("Can't fetch the data")
            }
            promise.fulfill()
        }
        queue.addOperation(operation)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFailOperation() {
        let promise = expectation(description: "Waiting for data load")

        let operation = LoadOperation(url: URL(string: "http://test.com/2")!, session: session)
        operation.handler = { result in
            switch result {
            case let .failure(error as NetworkError):
                XCTAssertEqual(error, NetworkError.notFound)
            default:
                XCTFail("Can't fetch the data")
            }
            promise.fulfill()
        }
        queue.addOperation(operation)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCancel() {

    }
}
