//
//  ViewControllerFactory.swift
//  Downloader_ExampleTests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

protocol ViewControllerFactory {
    func makeBoardViewController() -> BoardViewController
}

extension RootFactory: ViewControllerFactory {
    func makeBoardViewController() -> BoardViewController {
        let modelController = BoardModelController(service: makeBoardService())
        return BoardViewController(modelController: modelController)
    }
}
