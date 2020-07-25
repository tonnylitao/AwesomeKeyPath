//
//  KPPrefixOperators.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 24/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation


extension KeyPath where Value == Bool {
    
    public static prefix func ! (_ lhs: KeyPath) -> (Root) -> Bool {
        { !($0[keyPath: lhs]) }
    }
}

public prefix func ! <Root>(_ lhs: @escaping (Root) -> Bool) -> (Root) -> Bool {
    { !(lhs($0)) }
}


extension KeyPath where Value: BinaryInteger {
    
    public static prefix func ~ (_ lhs: KeyPath) -> (Root) -> Value {
        { ~($0[keyPath: lhs]) }
    }
}

public prefix func ~ <Root, Value: BinaryInteger>(_ lhs: @escaping (Root) -> Value) -> (Root) -> Value {
    { ~(lhs($0)) }
}


extension KeyPath where Value: AdditiveArithmetic {
    
    public static prefix func + (_ lhs: KeyPath) -> (Root) -> Value {
        { +($0[keyPath: lhs]) }
    }
    
}

public prefix func + <Root, Value: AdditiveArithmetic>(_ lhs: @escaping (Root) -> Value) -> (Root) -> Value {
    { +(lhs($0)) }
}


extension KeyPath where Value: SignedNumeric {
    
    public static prefix func - (_ lhs: KeyPath) -> (Root) -> Value {
        { -($0[keyPath: lhs]) }
    }
}

public prefix func - <Root, Value: SignedNumeric>(_ lhs: @escaping (Root) -> Value) -> (Root) -> Value {
    { -(lhs($0)) }
}


extension KeyPath where Value: Comparable {
    
    public static prefix func ..< (_ lhs: KeyPath) -> (Root) -> PartialRangeUpTo<Value> {
        { ..<($0[keyPath: lhs]) }
    }
    
    public static prefix func ... (_ lhs: KeyPath) -> (Root) -> PartialRangeThrough<Value> {
        { ...($0[keyPath: lhs]) }
    }
}



