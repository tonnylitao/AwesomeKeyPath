//
//  KPInfixOperatorNilCoalescing.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 24/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation


public func ?? <Root, T>(_ lhs: KeyPath<Root, T?>, _ rhs: @autoclosure @escaping () throws -> T?) rethrows -> (Root) -> T? {
    {
        $0[keyPath: lhs] ?? (try? rhs())
    }
}

public func ?? <Root, T>(_ lhs: KeyPath<Root, T?>, _ rhs: KeyPath<Root, T?>) -> (Root) -> T? {
    {
        $0[keyPath: lhs] ?? $0[keyPath: rhs]
    }
}

public func ?? <Root, T>(_ lhs: KeyPath<Root, T?>, _ rhs: @escaping (Root) -> T?) -> (Root) -> T? {
    {
        $0[keyPath: lhs] ?? rhs($0)
    }
}

public func ?? <Root, T>(_ lhs: @escaping (Root) -> T?, _ rhs: KeyPath<Root, T?>) -> (Root) -> T? {
    {
        lhs($0) ?? $0[keyPath: rhs]
    }
}
