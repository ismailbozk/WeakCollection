//
//    WeakCollectionTests.swift
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


import XCTest
@testable import WeakCollection

fileprivate protocol SomeProtocol: AnyObject {
    var zoo: Int { get set }
    func foo() -> Bool
}

fileprivate class SomeClass: SomeProtocol {
    var zoo: Int
    init() {
        zoo = -1
    }
    init(zoo: Int) {
        self.zoo = zoo
    }
    func foo() -> Bool { return true }
}

class WeakCollectionTests: XCTestCase {
    func testRetaininig2() {
        let view1 = UIView()
        view1.tag = 1
        
        let lazyArray = WeakCollection(elements: [UIView(), UIView(), view1])
        
        let views = lazyArray.compactMap { $0 }
        XCTAssertTrue(views.count == 1)
        XCTAssertTrue(views.first!.tag == 1)
    }
    
    func testProtocols() {
        var weakClassProtocolArray = WeakCollection<SomeProtocol>(elements: [])
        weakClassProtocolArray.append(SomeClass())
        let someClass2 = SomeClass()
        weakClassProtocolArray.append(someClass2)
        
        let classInstances = weakClassProtocolArray.compactMap { $0 }
        XCTAssertTrue(classInstances.count == 1)
        XCTAssertTrue(classInstances.first!.foo())
    }
    
    func testDeletedObjects() {
        var someClass1: SomeClass? = SomeClass()
        let someClass2: SomeClass = SomeClass()
        let weakCollection = WeakCollection<SomeProtocol>(elements: [someClass1!, someClass2])
        var weakCollectionFiltered: [SomeProtocol]? = weakCollection.compactMap { $0 }
        XCTAssertTrue(weakCollectionFiltered!.count == 2)
        weakCollectionFiltered = nil
        someClass1 = nil
        weakCollectionFiltered = weakCollection.compactMap { $0 }
        XCTAssertTrue(weakCollectionFiltered!.count == 1)
    }
    
    func testCleanUp() {
        var var1: SomeClass? = SomeClass()
        let var2 = SomeClass()
        
        var weakCollection = WeakCollection<SomeProtocol>(elements: [var1!, var2])
        var1 = nil
        let var3 = SomeClass()
        weakCollection.append(var3)
        
        weakCollection.cleanUp()
        
        XCTAssertTrue(weakCollection.compactMap { $0 }.count == 2)
        XCTAssertTrue(weakCollection.compactMap { $0 }.first! === var2)
        XCTAssertTrue(weakCollection.compactMap { $0 }[1] === var3)
    }
    
    func testContains() {
        var var1: SomeClass? = SomeClass()
        let var2 = SomeClass()
        var weakCollection = WeakCollection<SomeProtocol>(elements: [var1!, var2])
        
        XCTAssertTrue(weakCollection.contains { $0 === var1})
        XCTAssertTrue(weakCollection.contains(weakElement: var1!))
        
        var1 = nil
        weakCollection.cleanUp()
        XCTAssertFalse(weakCollection.contains { $0 === var1})
    }
    
    func testStressCase() {
        var var00: SomeClass? = SomeClass()
        var00?.zoo = 0
        let var01: SomeClass = SomeClass()
        var01.zoo = 1
        var var02: SomeClass? = SomeClass()
        var02?.zoo = 2
        let var03: SomeClass = SomeClass()
        var03.zoo = 3
        var var04: SomeClass? = SomeClass()
        var04?.zoo = 4
        let var05: SomeClass = SomeClass()
        var05.zoo = 5
        var var06: SomeClass? = SomeClass()
        var06?.zoo = 6
        let var07: SomeClass = SomeClass()
        var07.zoo = 7
        var var08: SomeClass? = SomeClass()
        var08?.zoo = 8
        let var09: SomeClass = SomeClass()
        var09.zoo = 9
        var var10: SomeClass? = SomeClass()
        var10?.zoo = 10
        let var11: SomeClass = SomeClass()
        var11.zoo = 11
        var var12: SomeClass? = SomeClass()
        var12?.zoo = 12
        let var13: SomeClass = SomeClass()
        var13.zoo = 13
        var var14: SomeClass? = SomeClass()
        var14?.zoo = 14
        let var15: SomeClass = SomeClass()
        var15.zoo = 15
        var var16: SomeClass? = SomeClass()
        var16?.zoo = 16
        let var17: SomeClass = SomeClass()
        var17.zoo = 17
        var var18: SomeClass? = SomeClass()
        var18?.zoo = 18
        let var19: SomeClass = SomeClass()
        var19.zoo = 19
        
        var weakCollection =
        WeakCollection<SomeProtocol>(elements: [var00!, var01, var02!, var03, var04!, var05, var06!, var07, var08!, var09])
        weakCollection.append(var10!)
        weakCollection.append(var11)
        weakCollection.append(var12!)
        weakCollection.append(var13)
        weakCollection.append(var14!)
        weakCollection.append(var15)
        weakCollection.append(var16!)
        weakCollection.append(var17)
        weakCollection.append(var18!)
        weakCollection.append(var19)
        
        XCTAssertTrue(weakCollection.compactMap {$0}.count == 20)
        weakCollection.forEach {
            XCTAssertTrue($0.zoo >= 0)
            XCTAssertTrue($0.zoo < 20)
        }
        
        XCTAssertTrue(weakCollection.contains(weakElement: var00!))
        XCTAssertTrue(weakCollection.contains(weakElement: var01))
        XCTAssertTrue(weakCollection.contains(weakElement: var02!))
        XCTAssertTrue(weakCollection.contains(weakElement: var03))
        XCTAssertTrue(weakCollection.contains(weakElement: var04!))
        XCTAssertTrue(weakCollection.contains(weakElement: var05))
        XCTAssertTrue(weakCollection.contains(weakElement: var06!))
        XCTAssertTrue(weakCollection.contains(weakElement: var07))
        XCTAssertTrue(weakCollection.contains(weakElement: var08!))
        XCTAssertTrue(weakCollection.contains(weakElement: var09))
        XCTAssertTrue(weakCollection.contains(weakElement: var10!))
        XCTAssertTrue(weakCollection.contains(weakElement: var11))
        XCTAssertTrue(weakCollection.contains(weakElement: var12!))
        XCTAssertTrue(weakCollection.contains(weakElement: var13))
        XCTAssertTrue(weakCollection.contains(weakElement: var14!))
        XCTAssertTrue(weakCollection.contains(weakElement: var15))
        XCTAssertTrue(weakCollection.contains(weakElement: var16!))
        XCTAssertTrue(weakCollection.contains(weakElement: var17))
        XCTAssertTrue(weakCollection.contains(weakElement: var18!))
        XCTAssertTrue(weakCollection.contains(weakElement: var19))
        
        var00 = nil
        var02 = nil
        var04 = nil
        var06 = nil
        var08 = nil
        var10 = nil
        var12 = nil
        var14 = nil
        var16 = nil
        var18 = nil
        
        XCTAssertTrue(weakCollection.compactMap {$0}.count == 10)
        weakCollection.forEach { XCTAssertTrue($0.zoo % 2 == 1) }
        
        XCTAssertTrue(weakCollection.contains(weakElement: var01))
        XCTAssertTrue(weakCollection.contains(weakElement: var03))
        XCTAssertTrue(weakCollection.contains(weakElement: var05))
        XCTAssertTrue(weakCollection.contains(weakElement: var07))
        XCTAssertTrue(weakCollection.contains(weakElement: var09))
        XCTAssertTrue(weakCollection.contains(weakElement: var11))
        XCTAssertTrue(weakCollection.contains(weakElement: var13))
        XCTAssertTrue(weakCollection.contains(weakElement: var15))
        XCTAssertTrue(weakCollection.contains(weakElement: var17))
        XCTAssertTrue(weakCollection.contains(weakElement: var19))
    }
}
