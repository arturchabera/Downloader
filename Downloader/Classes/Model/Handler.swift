//
//  Result.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/13/19.
//

import Foundation

public typealias Handler<T> = (Result<T, Error>) -> Void
public typealias DataHandler = Handler<Data>
