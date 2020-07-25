//
//  KPClosure.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 22/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

extension KeyPath {
 
    public func getValue(_ root: Root) -> Value {
        root[keyPath: self]
    }
}

extension KeyPath {
    
    public var closure: (Root) -> Value {
        return { $0[keyPath: self] }
    }
    
    /*
     let closure1: (User) -> Bool = (\User.aString.count).closure{ $0 > 5 }
     
     let closure2: (User) -> Int = (\User.aString.count).closure{ $0 + 5 }
    */
    public func closure<NewValue>(_ closure: @escaping (Value) -> NewValue) -> (Root) -> NewValue {
        {
            closure( $0[keyPath: self] )
        }
    }
}
