//
//  KPInfixOperatorRangeFormation.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 24/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation


extension KeyPath where Value: Comparable {
    
    public static func ..< (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> Range<Value> {
        { $0[keyPath: lhs] ..< rhs }
    }
    
    public static func ..< (_ lhs: Value, _ rhs: KeyPath) -> (Root) -> Range<Value> {
        { lhs ..< $0[keyPath: rhs] }
    }
    
    public static func ..< (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> Range<Value> {
        { $0[keyPath: lhs] ..< $0[keyPath: rhs] }
    }
    
    public static func ..< (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> Range<Value> {
        { $0[keyPath: lhs] ..< rhs($0) }
    }
    
    public static func ..< (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> Range<Value> {
        { lhs($0) ..< $0[keyPath: rhs] }
    }
}

extension Comparable {

    public static func ..< <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> Range<Self> {
        { lhs($0) ..< rhs }
    }
    
    public static func ..< <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> Range<Self> {
        { lhs ..< rhs($0) }
    }
}

extension KeyPath where Value: Comparable {
    
    public static func ... (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> ClosedRange<Value> {
        { $0[keyPath: lhs] ... rhs }
    }
    
    public static func ... (_ lhs: Value, _ rhs: KeyPath) -> (Root) -> ClosedRange<Value> {
        { lhs ... $0[keyPath: rhs] }
    }
    
    public static func ... (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> ClosedRange<Value> {
        { $0[keyPath: lhs] ... $0[keyPath: rhs] }
    }
    
    public static func ... (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> ClosedRange<Value> {
        { $0[keyPath: lhs] ... rhs($0) }
    }
    
    public static func ... (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> ClosedRange<Value> {
        { lhs($0) ... $0[keyPath: rhs] }
    }
}

extension Comparable {

    public static func ... <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> ClosedRange<Self> {
        { lhs($0) ... rhs }
    }
    
    public static func ... <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> ClosedRange<Self> {
        { lhs ... rhs($0) }
    }
}
