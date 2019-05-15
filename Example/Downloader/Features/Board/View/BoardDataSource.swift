//
//  BoardDataSource.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class BoardDataSource: NSObject, UICollectionViewDataSource {
    var pins: Board = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PinCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.presentation = PinPresentation(pin: pins[indexPath.item])
        return cell
    }
}
