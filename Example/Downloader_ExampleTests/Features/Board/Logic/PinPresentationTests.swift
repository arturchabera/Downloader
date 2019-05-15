//
//  PinPresentation.swift
//  Downloader_ExampleTests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Downloader_Example

class PinPresentationTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUp() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func testPresentation() throws {
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "board", ofType: "json")
            else {
                XCTFail("Can't find file board.json")
                return
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let board = try decoder.decode(Board.self, from: data)
        if let pin = board.first {
            let presentation = PinPresentation(pin: pin)
            XCTAssertEqual(presentation.avatarUrl?.absoluteString, "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128&s=622a88097cf6661f84cd8942d851d9a2")
            XCTAssertEqual(presentation.imageUrl?.absoluteString, "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=1881cd689e10e5dca28839e68678f432")
            XCTAssertEqual(presentation.username, "Nicholas Kampouris")
        } else {
            XCTFail("Failed to get first pin from board")
        }
    }
}
