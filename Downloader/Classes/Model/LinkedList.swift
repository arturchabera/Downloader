//
//  LinkedList.swift
//  Downloader
//
//  Created by Majid Jabrayilov on 5/13/19.
//

import Foundation

public final class LinkedList<T> {
    public class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?

        public init(value: T) {
            self.value = value
        }
    }

    public typealias Node = LinkedListNode<T>

    private var head: Node?

    public init() {}

    public var isEmpty: Bool {
        return head == nil
    }

    public var first: Node? {
        return head
    }

    public var last: Node? {
        if var node = head {
            while let next = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }

    public var count: Int {
        if var node = head {
            var c = 1
            while let next = node.next {
                node = next
                c += 1
            }
            return c
        } else {
            return 0
        }
    }

    public func append(_ value: T) {
        let newNode = Node(value: value)
        self.append(newNode)
    }

    public func append(_ node: Node) {
        let newNode = LinkedListNode(value: node.value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }

    private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
        var i = index
        var next = head
        var previous: Node?

        while next != nil && i > 0 {
            i -= 1
            previous = next
            next = next!.next
        }

        return (previous, next)
    }

    public func insert(_ value: T, atIndex index: Int) {
        let newNode = Node(value: value)
        self.insert(newNode, atIndex: index)
    }

    public func insert(_ node: Node, atIndex index: Int) {
        let (previous, next) = nodesBeforeAndAfter(index: index)
        let newNode = LinkedListNode(value: node.value)
        newNode.previous = previous
        newNode.next = next
        previous?.next = newNode
        next?.previous = newNode

        if previous == nil {
            head = newNode
        }
    }

    public func removeAll() {
        head = nil
    }

    @discardableResult
    public func remove(node: Node) -> T {
        let previous = node.previous
        let next = node.next

        if let previous = previous {
            previous.next = next
        } else {
            head = next
        }
        next?.previous = previous

        node.previous = nil
        node.next = nil
        return node.value
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var output = "["
        var node = head
        while let next = node {
            output += "\(next.value)"
            node = next.next
            if node != nil { output += ", " }
        }
        return output + "]"
    }
}
