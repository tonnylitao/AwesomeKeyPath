//
//  KPInfixOperatorAssignment.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 25/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

extension WritableKeyPath where Value: AdditiveArithmetic {
    
    public static func += (_ lhs: WritableKeyPath, _ rhs: Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] + rhs }
    }
    
    public static func += (_ lhs: WritableKeyPath, _ rhs: KeyPath<Root, Value>) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] + $0[keyPath: rhs] }
    }
    
    public static func += (_ lhs: WritableKeyPath, _ rhs: @escaping (Root) -> Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] + rhs($0) }
    }
}


extension WritableKeyPath where Value: AdditiveArithmetic {
    
    public static func -= (_ lhs: WritableKeyPath, _ rhs: Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] - rhs }
    }
    
    public static func -= (_ lhs: WritableKeyPath, _ rhs: KeyPath<Root, Value>) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] - $0[keyPath: rhs] }
    }
    
    public static func -= (_ lhs: WritableKeyPath, _ rhs: @escaping (Root) -> Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] - rhs($0) }
    }
}

extension WritableKeyPath where Value: Numeric {
    
    public static func *= (_ lhs: WritableKeyPath, _ rhs: Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] * rhs }
    }
    
    public static func *= (_ lhs: WritableKeyPath, _ rhs: KeyPath<Root, Value>) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] * $0[keyPath: rhs] }
    }
    
    public static func *= (_ lhs: WritableKeyPath, _ rhs: @escaping (Root) -> Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] * rhs($0) }
    }
}


extension WritableKeyPath where Value: BinaryInteger {
    
    public static func /= (_ lhs: WritableKeyPath, _ rhs: Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] / rhs }
    }
    
    public static func /= (_ lhs: WritableKeyPath, _ rhs: KeyPath<Root, Value>) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] / $0[keyPath: rhs] }
    }
    
    public static func /= (_ lhs: WritableKeyPath, _ rhs: @escaping (Root) -> Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] / rhs($0) }
    }
}

extension WritableKeyPath where Value: FloatingPoint {
    
    public static func /= (_ lhs: WritableKeyPath, _ rhs: Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] / rhs }
    }
    
    public static func /= (_ lhs: WritableKeyPath, _ rhs: KeyPath<Root, Value>) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] / $0[keyPath: rhs] }
    }
    
    public static func /= (_ lhs: WritableKeyPath, _ rhs: @escaping (Root) -> Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] / rhs($0) }
    }
}

extension WritableKeyPath where Value: BinaryInteger {
    
    public static func %= (_ lhs: WritableKeyPath, _ rhs: Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] % rhs }
    }
    
    public static func %= (_ lhs: WritableKeyPath, _ rhs: KeyPath<Root, Value>) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] % $0[keyPath: rhs] }
    }
    
    public static func %= (_ lhs: WritableKeyPath, _ rhs: @escaping (Root) -> Value) -> (inout Root) -> () {
        { $0[keyPath: lhs] = $0[keyPath: lhs] % rhs($0) }
    }
}
