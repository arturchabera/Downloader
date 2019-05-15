//
//  BoardViewController.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class BoardViewController: UICollectionViewController {
    private enum Layout {
        static let pagingOffset: CGFloat = 100
    }

    private let modelController: BoardModelController
    private let dataSource = BoardDataSource()

    init(modelController: BoardModelController) {
        self.modelController = modelController
        super.init(collectionViewLayout: BoardLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        fetch()
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let distance = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.height)
        if distance < Layout.pagingOffset {
            fetchNextPage()
        }
    }
}

extension BoardViewController {
    @objc
    private func fetch() {
        collectionView.refreshControl?.beginRefreshing()
        modelController.fetch { [weak self] outcome in
            DispatchQueue.main.async {
                self?.renderBoard()
            }
        }
    }

    private func fetchNextPage() {
        modelController.fetchNextPage { [weak self] outcome in
            DispatchQueue.main.async {
                self?.renderBoard()
            }
        }
    }

    private func renderBoard() {
        collectionView.refreshControl?.endRefreshing()
        dataSource.pins = modelController.board
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        title = "Board"
        collectionView.backgroundColor = .white
        collectionView.register(PinCell.self)
        collectionView.dataSource = dataSource
    }

    private func setupRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }
}
