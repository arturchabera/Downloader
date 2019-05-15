//
//  FlowController.swift
//  Downloader_ExampleTests
//
//  Created by Majid Jabrayilov on 5/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class FlowController: UIViewController {
    private let navigationVC = UINavigationController()

    private let factory: ViewControllerFactory

    init(factory: ViewControllerFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationVC.pushViewController(factory.makeBoardViewController(), animated: true)
        add(navigationVC)
    }
}
