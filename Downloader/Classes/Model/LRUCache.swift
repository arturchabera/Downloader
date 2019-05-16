//
//  LRUCache.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/13/19.
//

import Foundation

public class LRUCache<Key: Hashable, Value> {
    private let maxSize: Int
    private var cache: [Key: Value] = [:]
    private var priority: LinkedList<Key> = LinkedList<Key>()
    private var key2node: [Key: LinkedList<Key>.LinkedListNode<Key>] = [:]

    public init(_ maxSize: Int) {
        self.maxSize = maxSize
    }

    public func get(_ key: Key) -> Value? {
        guard let value = cache[key] else {
            return nil
        }

        remove(key)
        insert(key, value: value)

        return value
    }

    public func set(_ key: Key, value: Value) {
        if cache[key] != nil {
            remove(key)
        } else if priority.count >= maxSize, let keyToRemove = priority.last?.value {
            remove(keyToRemove)
        }

        insert(key, value: value)
    }

    private func remove(_ key: Key) {
        cache.removeValue(forKey: key)
        guard let node = key2node[key] else {
            return
        }
        priority.remove(node: node)
        key2node.removeValue(forKey: key)
    }

    private func insert(_ key: Key, value: Value) {
        cache[key] = value
        priority.insert(key, atIndex: 0)
        guard let first = priority.first else {
            return
        }
        key2node[key] = first
    }
}
