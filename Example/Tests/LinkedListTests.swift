//
//  LinkedListTests.swift
//  Downloader_Tests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Downloader

class LinkedListTests: XCTestCase {
    func testBasicOperations() {
        let list = LinkedList<Int>()
        XCTAssertTrue(list.isEmpty)
        list.append(.init(integerLiteral: 1))
        list.append(.init(integerLiteral: 2))
        let last = list.last
        list.insert(.init(integerLiteral: 0), atIndex: 0)
        _ = last.map { list.remove(node: $0) }
        XCTAssertEqual(list.description, "[0, 1]")
    }
}
