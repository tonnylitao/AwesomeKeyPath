//
//  KPValidation.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

public protocol KPValidation {}

extension KPValidation {
    
    public func validate(_ rules: KeyPath<Self, Bool>...) -> Bool {
        
        for rule in rules where self[keyPath: rule] == false {
            return false
        }
        
        return true
    }
    
    public func validate(_ rules: ((Self) -> Bool)...) -> Bool {
        
        for rule in rules where rule(self) == false {
            return false
        }
        
        return true
    }
}


