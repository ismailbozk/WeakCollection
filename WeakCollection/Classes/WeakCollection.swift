//
//    WeakCollection.swift
//
//    Copyright (c) 2020 Ismail Bozkurt <ismailbozk@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.


import Foundation

/// Single weak object container.
final private class WeakObject {

    weak var unbox: AnyObject?

    init?(_ value: Any) {
        guard Mirror(reflecting: value).displayStyle == .class else {
            assertionFailure("\(value) must be an Object")
            return nil
        }

        unbox = value as AnyObject
    }
}

/**
 # Weak Array Collection
 A weak reference collection for **multicast delegation**.
 
 **Note:** *Element*s should be **non-optional** class objects, otherwise they will be ignored.
 */
public struct WeakCollection<Element> {

    fileprivate var items: [WeakObject]

    public init(elements: [Element] = []) {
        items = elements.compactMap { element in
            guard let weakObject = WeakObject(element) else {
                return nil
            }
            return weakObject
        }
    }
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter newElement: The element to append to the array.
    public mutating func append(_ newElement: Element) {
        cleanUp()
        guard let weakObject = WeakObject(newElement) else {
            return
        }
        items.append(weakObject)
    }

    /// Removes the deallocated items from the collection.
    public mutating func cleanUp() {
        items = items.compactMap { item in
            guard item.unbox != nil else { return nil }
            return item
        }
    }

    /// Returns a Boolean value indicating whether the sequence contains the
    /// given element.
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: `true` if the element was found in the sequence; otherwise,
    ///   `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    public func contains(weakElement element: Element) -> Bool {
        return contains { $0 as AnyObject === element as AnyObject }
    }

}

extension WeakCollection: Sequence {

    public func makeIterator() -> WeakIterator<Element> {
        return WeakIterator(weakArray: self)
    }
}

extension WeakCollection {
    mutating func appendUnique(_ element: Element) {
        cleanUp()
        
        guard !contains(weakElement: element) else {
            return
        }
        
        append(element)
    }
}

public struct WeakIterator<Element: Any>: IteratorProtocol {

    let weakArray: WeakCollection<Element>

    private var index: Int
    
    init(weakArray: WeakCollection<Element>) {
        self.weakArray = weakArray
        self.index = 0
    }
    
    public mutating func next() -> Element? {
        guard index < weakArray.items.count else { return nil }
        
        if let item = weakArray.items[index].unbox as? Element {
            index += 1
            return item
        }
        
        index += 1
        return next()
    }

}
