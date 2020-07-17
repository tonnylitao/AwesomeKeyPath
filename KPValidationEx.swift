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
    var isEmail: Bool {
        return false
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
