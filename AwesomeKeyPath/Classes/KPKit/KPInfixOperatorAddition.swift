//
//  KPInfixOperatorAddition.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 24/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation


extension KeyPath where Value: AdditiveArithmetic {
    
    public static func + (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] + rhs }
    }
    
    public static func + (_ rhs: Value, _ lhs: KeyPath) -> (Root) -> (Value) {
        { rhs + $0[keyPath: lhs] }
    }
    
    public static func + (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> (Value) {
        { $0[keyPath: lhs] + $0[keyPath: rhs] }
    }
    
    public static func + (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] + rhs($0) }
    }
    
    public static func + (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> (Value) {
        { lhs($0) + $0[keyPath: rhs] }
    }
}

extension AdditiveArithmetic {

    public static func + <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> Self {
        { lhs($0) + rhs }
    }
    
    public static func + <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> Self {
        { lhs + rhs($0) }
    }
}


extension KeyPath where Value: AdditiveArithmetic {
    
    public static func - (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] - rhs }
    }
    
    public static func - (_ rhs: Value, _ lhs: KeyPath) -> (Root) -> (Value) {
        { rhs - $0[keyPath: lhs] }
    }
    
    public static func - (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> (Value) {
        { $0[keyPath: lhs] - $0[keyPath: rhs] }
    }
    
    public static func - (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] - rhs($0) }
    }
    
    public static func - (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> (Value) {
        { lhs($0) - $0[keyPath: rhs] }
    }
}

extension AdditiveArithmetic {

    public static func - <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> Self {
        { lhs($0) - rhs }
    }
    
    public static func - <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> Self {
        { lhs - rhs($0) }
    }
}


extension KeyPath where Value: FixedWidthInteger {
    
    public static func &+ (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] &+ rhs }
    }
    
    public static func &+ (_ rhs: Value, _ lhs: KeyPath) -> (Root) -> (Value) {
        { rhs &+ $0[keyPath: lhs] }
    }
    
    public static func &+ (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> (Value) {
        { $0[keyPath: lhs] &+ $0[keyPath: rhs] }
    }
    
    public static func &+ (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] &+ rhs($0) }
    }
    
    public static func &+ (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> (Value) {
        { lhs($0) &+ $0[keyPath: rhs] }
    }
}

extension FixedWidthInteger {

    public static func &+ <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> Self {
        { lhs($0) &+ rhs }
    }
    
    public static func &+ <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> Self {
        { lhs &+ rhs($0) }
    }
}


extension KeyPath where Value: FixedWidthInteger {
    
    public static func &- (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] &- rhs }
    }
    
    public static func &- (_ rhs: Value, _ lhs: KeyPath) -> (Root) -> (Value) {
        { rhs &- $0[keyPath: lhs] }
    }
    
    public static func &- (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> (Value) {
        { $0[keyPath: lhs] &- $0[keyPath: rhs] }
    }
    
    public static func &- (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] &- rhs($0) }
    }
    
    public static func &- (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> (Value) {
        { lhs($0) &- $0[keyPath: rhs] }
    }
}

extension FixedWidthInteger {

    public static func &- <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> Self {
        { lhs($0) &- rhs }
    }
    
    public static func &- <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> Self {
        { lhs &- rhs($0) }
    }
}


extension KeyPath where Value: FixedWidthInteger {
    
    public static func ^ (_ lhs: KeyPath, _ rhs: Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] ^ rhs }
    }
    
    public static func ^ (_ rhs: Value, _ lhs: KeyPath) -> (Root) -> (Value) {
        { rhs ^ $0[keyPath: lhs] }
    }
    
    public static func ^ (_ lhs: KeyPath, _ rhs: KeyPath) -> (Root) -> (Value) {
        { $0[keyPath: lhs] ^ $0[keyPath: rhs] }
    }
    
    public static func ^ (_ lhs: KeyPath, _ rhs: @escaping (Root) -> Value) -> (Root) -> (Value) {
        { $0[keyPath: lhs] ^ rhs($0) }
    }
    
    public static func ^ (_ lhs: @escaping (Root) -> Value, _ rhs: KeyPath) -> (Root) -> (Value) {
        { lhs($0) ^ $0[keyPath: rhs] }
    }
}

extension FixedWidthInteger {

    public static func ^ <Root>(_ lhs: @escaping (Root) -> Self, _ rhs: Self) -> (Root) -> Self {
        { lhs($0) ^ rhs }
    }
    
    public static func ^ <Root>(_ lhs: Self, _ rhs: @escaping (Root) -> Self) -> (Root) -> Self {
        { lhs ^ rhs($0) }
    }
}
