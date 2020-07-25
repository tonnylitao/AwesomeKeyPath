//
//  KPInfixOperatorLogical.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 24/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation


extension KeyPath where Value == Bool {
    
    public static func && (_ lhs: KeyPath, _ rhs: @autoclosure @escaping () -> Bool) -> (Root) -> Bool {
        { $0[keyPath: lhs] && rhs() }
    }
    
    public static func && (_ lhs: KeyPath, _ rhs: @autoclosure @escaping () -> KeyPath) -> (Root) -> Bool {
        { $0[keyPath: lhs] && $0[keyPath: rhs()] }
    }
    
    public static func && (_ lhs: KeyPath, _ rhs: @autoclosure @escaping () -> (Root) -> Bool) -> (Root) -> Bool {
        { $0[keyPath: lhs] && rhs()($0) }
    }
}

public func && <Root>(_ lhs: @escaping (Root) -> Bool, _ rhs: @autoclosure @escaping () -> KeyPath<Root, Bool>) -> (Root) -> Bool {
    { lhs($0) && $0[keyPath: rhs()] }
}

extension Bool {
    
    public static func && <Root>(_ lhs: Bool, _ rhs: @autoclosure @escaping () -> KeyPath<Root, Bool>) -> (Root) -> Bool {
        { lhs && $0[keyPath: rhs()] }
    }
    
    public static func && <Root>(_ lhs: Bool, _ rhs: @autoclosure @escaping () -> (Root) -> Bool) -> (Root) -> Bool {
        { lhs && rhs()($0) }
    }
}

public func && <Root>(_ lhs: @escaping (Root) -> Bool, _ rhs: @autoclosure @escaping () -> Bool) -> (Root) -> Bool {
    { lhs($0) && rhs() }
}

public func && <Root>(_ lhs: @escaping (Root) -> Bool, _ rhs: @autoclosure @escaping () -> (Root) -> Bool) -> (Root) -> Bool {
    { lhs($0) && rhs()($0) }
}

extension KeyPath where Value == Bool {
    
    public static func || (_ lhs: KeyPath, _ rhs: @autoclosure @escaping () -> Bool) -> (Root) -> Bool {
        { $0[keyPath: lhs] || rhs() }
    }
    
    public static func || (_ lhs: KeyPath, _ rhs: @autoclosure @escaping () -> KeyPath) -> (Root) -> Bool {
        { $0[keyPath: lhs] || $0[keyPath: rhs()] }
    }
    
    public static func || (_ lhs: KeyPath, _ rhs: @autoclosure @escaping () -> (Root) -> Bool) -> (Root) -> Bool {
        { $0[keyPath: lhs] || rhs()($0) }
    }
}

public func || <Root>(_ lhs: @escaping (Root) -> Bool, _ rhs: @autoclosure @escaping () -> KeyPath<Root, Bool>) -> (Root) -> Bool {
    { lhs($0) || $0[keyPath: rhs()] }
}

extension Bool {
    
    public static func || <Root>(_ lhs: Bool, _ rhs: @autoclosure @escaping () -> KeyPath<Root, Bool>) -> (Root) -> Bool {
        { lhs || $0[keyPath: rhs()] }
    }
    
    public static func || <Root>(_ lhs: Bool, _ rhs: @autoclosure @escaping () -> (Root) -> Bool) -> (Root) -> Bool {
        { lhs || rhs()($0) }
    }
}

public func || <Root>(_ lhs: @escaping (Root) -> Bool, _ rhs: @autoclosure @escaping () -> Bool) -> (Root) -> Bool {
    { lhs($0) || rhs() }
}

public func || <Root>(_ lhs: @escaping (Root) -> Bool, _ rhs: @autoclosure @escaping () -> (Root) -> Bool) -> (Root) -> Bool {
    { lhs($0) || rhs()($0) }
}
