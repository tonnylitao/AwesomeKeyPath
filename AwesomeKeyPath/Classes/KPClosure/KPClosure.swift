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
    
    /*
     let closure1: (User) -> Bool = (\User.aString.count).apply{ $0 > 5 }
     
     let closure2: (User) -> Int = (\User.aString.count).apply{ $0 + 5 }
    */
    func apply<NewValue>(_ closure: @escaping (Value) -> NewValue) -> (Root) -> NewValue {
        return { closure( $0[keyPath: self] ) }
    }
}
