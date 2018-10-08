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

struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    
    mutating func next() -> Substring? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}

struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

for prefix in PrefixSequence(string: "HelloWorld") {
    print(prefix)
}

func fibsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0+state.1)
        return upcomingNumber
    }
}

let fibsSequence = AnySequence(fibsIterator)

print(Array(fibsSequence.prefix(10)))

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

let list: List = [1,2,3]
for x in list {
    print("\(x)", terminator: "")
}
