//
//  URLProtocolMock.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case notFound
}

class URLProtocolMock: URLProtocol {
    public static let mockUrl = URL(string: "http://test.com/1")!
    private static var mockData: [URL: Data] = {
        var mock: [URL: Data] = [:]
        mock[URLProtocolMock.mockUrl] = "1".data(using: .utf8)
        return mock
    }()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        sleep(1)
        
        if let url = request.url, let data = URLProtocolMock.mockData[url] {
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            self.client?.urlProtocol(self, didFailWithError: NetworkError.notFound)
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
