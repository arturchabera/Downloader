//
//  LRUCacheTests.swift
//  Downloader_Tests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Downloader

class LRUCacheTests: XCTestCase {
    func testBasicOperations() {
        let cache = LRUCache<String, String>(2)

        cache.set("1", value: "a")
        cache.set("2", value: "b")
        cache.set("3", value: "c")
        cache.set("4", value: "d")

        XCTAssertEqual(cache.get("1"), nil)
        XCTAssertEqual(cache.get("2"), nil)
        XCTAssertEqual(cache.get("3"), "c")
        XCTAssertEqual(cache.get("4"), "d")
    }
}
