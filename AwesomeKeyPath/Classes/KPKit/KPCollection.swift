//
//  KPCollection.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 23/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

extension Sequence {
    
    public func filter<Value>(_ keyPath: KeyPath<Element, Value>, _ closure: (Value) -> Bool) -> [Element] {
        return self.filter { closure($0[keyPath: keyPath]) }
    }
    
    public func map<Value, NewValue>(_ keyPath: KeyPath<Element, Value>, _ closure: (Value) -> NewValue) -> [NewValue] {
        return self.map { closure($0[keyPath: keyPath]) }
    }
    
    public func forEach<Value>(_ keyPath: KeyPath<Element, Value>, _ closure: ((Value) -> ())) {
        return self.forEach { closure($0[keyPath: keyPath]) }
    }
    
    public func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        return self.sorted(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }
}
