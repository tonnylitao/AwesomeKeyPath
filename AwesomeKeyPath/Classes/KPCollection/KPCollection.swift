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
    
    func filter<Value>(_ keyPath: KeyPath<Element, Value>, _ closure: ((Value) -> Bool)? = nil) -> [Element] {
        return self.filter { closure?($0[keyPath: keyPath]) ?? $0[keyPath: keyPath] as? Bool ?? false }
    }
    
    func map<Value, NewValue>(_ keyPath: KeyPath<Element, Value>, _ closure: ((Value) -> NewValue)? = nil) -> [NewValue] {
        return self.map { closure?($0[keyPath: keyPath]) ?? $0[keyPath: keyPath] as! NewValue }
    }
    
    func forEach<Value>(_ keyPath: KeyPath<Element, Value>, _ closure: ((Value) -> ())) {
        return self.forEach { closure($0[keyPath: keyPath]) }
    }
}
