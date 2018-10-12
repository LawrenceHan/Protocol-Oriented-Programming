//
//  main.swift
//  POP Test
//
//  Created by Hanguang on 16/06/2017.
//  Copyright © 2017 hanguang. All rights reserved.
//

import Foundation

print("Hello, World!")

let suits = ["♠", "♥", "♣", "♦"]
let ranks = ["J", "Q", "K", "A"]

let result = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}

print(result)

var fibs = [1,1,2,3,5,8,13]
let slice = fibs[1...]

fibs.append(21)

print(slice)
print(fibs)

extension Sequence where Element: Hashable {
    var frequencies: [Element: Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}

let frequencies = "Hello World".frequencies
print(frequencies)

let letters = ..."z"
if letters.contains("b") {
    print("YES")
}

struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0+state.1)
        return upcomingNumber
    }
}

struct PrefixIterator<Base: Collection>: IteratorProtocol, Sequence {
    let base: Base
    var offset: Base.Index
    
    init(_ base: Base) {
        self.base = base
        self.offset = base.startIndex
    }
    
    mutating func next() -> Base.SubSequence? {
        guard offset < base.endIndex else { return nil }
        base.formIndex(after: &offset)
        return base.prefix(upTo: offset)
    }
}

//struct PrefixSequence: Sequence {
//    let string: String
//    func makeIterator() -> PrefixIterator {
//        return PrefixIterator(string)
//    }
//}

//for prefix in PrefixSequence(string: "HelloWorld") {
//    print(prefix)
//}

func fibsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0+state.1)
        return upcomingNumber
    }
}

let fibsSequence = AnySequence(fibsIterator)

print(Array(fibsSequence.prefix(8)))

let standardIn = AnySequence {
    return AnyIterator {
        readLine()
    }
}

let numberedStdIn = standardIn.enumerated()
//for (i, line) in numberedStdIn {
//    print("\(i+1): \(line)")
//}

extension Sequence where Element: Equatable {
    func headMirrorsTail(_ n: Int) -> Bool {
        let head = prefix(n)
        let tail = suffix(n).reversed()
        return head.elementsEqual(tail)
    }
}

let check = [1,2,3,4,2,1].headMirrorsTail(2)
print(check)

enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

extension List {
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in
            partialList.cons(element)
        }
    }
}

extension List {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
    mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(x, next: tail):
            self = tail
            return x
        }
    }
}

extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}

//let list: List = [1,2,3]
//for x in list {
//    print("\(x)", terminator: "")
//}

protocol Queue {
    associatedtype Element
    mutating func enqueue(_ newElement: Element)
    mutating func dequeue() -> Element?
}

struct FIFOQueue<Element>: Queue {
    var left: [Element] = []
    var right: [Element] = []
    
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    var startIndex: Int { return 0 }
    var endIndex: Int { return left.count+right.count }
    
    func index(after i: Int) -> Int {
        precondition(i<endIndex)
        return i+1
    }
    
    subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count-position-1]
        } else {
            return right[position-left.count]
        }
    }
}

extension FIFOQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        left = elements.reversed()
        right = []
    }
}

extension Substring {
    var nextWordRange: Range<Index> {
        let start = drop(while: { $0 == " "})
        let end = start.index(where: { $0 == " "}) ?? endIndex
        return start.startIndex..<end
    }
}

struct WordsIndex: Comparable {
    fileprivate let range: Range<Substring.Index>
    fileprivate init(_ value: Range<Substring.Index>) {
        self.range = value
    }
    
    static func <(lhs: WordsIndex, rhs: WordsIndex) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
    
    static func ==(lhs: WordsIndex, rhs: WordsIndex) -> Bool {
        return lhs.range == rhs.range
    }
}

struct Words: Collection {
    let string: Substring
    let startIndex: WordsIndex
    
    init(_ s: String) {
        self.init(s[...])
    }
    
    private init(_ s: Substring) {
        self.string = s
        self.startIndex = WordsIndex(string.nextWordRange)
    }
    
    var endIndex: WordsIndex {
        let e = string.endIndex
        return WordsIndex(e..<e)
    }
    
    subscript(index: WordsIndex) -> Substring {
        return string[index.range]
    }
    
    func index(after i: WordsIndex) -> WordsIndex {
        guard i.range.upperBound < string.endIndex else { return endIndex }
        let remainder = string[i.range.upperBound...]
        return WordsIndex(remainder.nextWordRange)
    }
    
    subscript(range: Range<WordsIndex>) -> Words {
        let start = range.lowerBound.range.lowerBound
        let end = range.upperBound.range.upperBound
        return Words(string[start..<end])
    }
}

let array = Words(" hello world test ")
print(Array(array.prefix(2)))
