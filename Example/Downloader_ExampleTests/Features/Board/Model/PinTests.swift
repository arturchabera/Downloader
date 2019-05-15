//
//  PinTests.swift
//  Downloader_ExampleTests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Downloader_Example

class PinTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUp() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func testParsing() throws {
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "board", ofType: "json")
            else {
                XCTFail("Can't find file board.json")
                return
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let board = try decoder.decode(Board.self, from: data)

        XCTAssertEqual(board.count, 10)

        let pin = board.first
        
        XCTAssertEqual(pin?.id, "4kQA1aQK8-Y")
        XCTAssertEqual(pin?.urls.regular, "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=1881cd689e10e5dca28839e68678f432")
        XCTAssertEqual(pin?.urls.full, "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=4b142941bfd18159e2e4d166abcd0705")
        XCTAssertEqual(pin?.urls.small, "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=d5682032c546a3520465f2965cde1cec")
        XCTAssertEqual(pin?.urls.thumb, "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max&s=9fba74be19d78b1aa2495c0200b9fbce")

        let user = pin?.user

        XCTAssertEqual(user?.name, "Nicholas Kampouris")
        XCTAssertEqual(user?.username, "nicholaskampouris")
        XCTAssertEqual(user?.id, "OevW4fja2No")
        XCTAssertEqual(user?.profileImage.large, "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128&s=622a88097cf6661f84cd8942d851d9a2")
        XCTAssertEqual(user?.profileImage.medium, "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64&s=ef631d113179b3137f911a05fea56d23")
        XCTAssertEqual(user?.profileImage.small, "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32&s=63f1d805cffccb834cf839c719d91702")
    }
}
