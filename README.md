# WeakCollection

[![Version](https://img.shields.io/cocoapods/v/WeakCollection.svg?style=flat)](https://cocoapods.org/pods/WeakCollection)
[![License](https://img.shields.io/cocoapods/l/WeakCollection.svg?style=flat)](https://cocoapods.org/pods/WeakCollection)
[![Platform](https://img.shields.io/cocoapods/p/WeakCollection.svg?style=flat)](https://cocoapods.org/pods/WeakCollection)

## Example

WeakCollection is a collection that holds only non-optional class type objects in its self without increasing the reference count the given object. If te given item is optional or a struct type, it will being dicarded completely.  
### Any Type collection

```
import WeakCollection

let weakCollection = WeakCollection(elements: [UIView(), UIView(), UIView()])
// all the UIView instances will be released from the memory after initializing the weakCollection.
let views = lazyArray.compactMap { $0 }
// views.count will be 0
```


### Multicast  Delegation 

With WeakCollectin you can defined collections like you define any regular array;

`var weakClassProtocolArray = WeakCollection<SomeProtocol>(elements: [])`
_weakClassProtocolArray_ will only accept  _SomeProtocol_ class type object. Otherwise Xcode will produce an _expected type_ compile error.


```
protocol SomeProtocol: AnyObject {
    var zoo: Int { get set }
    func foo() -> Bool
}

class SomeClass: SomeProtocol {
    var zoo: Int
    init() {
        zoo = -1
    }
    init(zoo: Int) {
        self.zoo = zoo
    }
    func foo() -> Bool { return true }
}

var someClass1: SomeClass? = SomeClass()
let someClass2: SomeClass = SomeClass()
let weakCollection = WeakCollection<SomeProtocol>(elements: [someClass1!, someClass2])
// init a weak Collection with some already retained class type objects. 

someClass1 = nil
let weakCollectionFiltered = weakCollection.compactMap { $0 }
// At this point only someClass2 will be on memory. someClass1 will be already deleted. 

```

## Requirements

Min iOS version 10 project.

## Installation

Simply add the following line to your Podfile:

```ruby
pod 'WeakCollection'
```

## Author

Ismail Bozkurt, ismailbozk@gmail.com

## License

WeakCollection is available under the MIT license. See the LICENSE file for more info.
