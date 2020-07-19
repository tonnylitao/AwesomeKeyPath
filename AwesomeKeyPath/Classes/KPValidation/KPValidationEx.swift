//
//  KPValidationEx.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

public extension String {
    
    static let emailRegEx = "[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)"
    
    var isEmail: Bool {
        return NSPredicate(format:"SELF MATCHES[c] %@", Self.emailRegEx).evaluate(with: self)
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension Optional {
    
    var isSome: Bool {
        return self != nil
    }
}

public extension Bool {
    
    var not: Bool {
        return !self
    }
}
