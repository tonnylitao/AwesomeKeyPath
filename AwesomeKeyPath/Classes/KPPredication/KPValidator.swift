//
//  KPValidator.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

public protocol KPValidation {
    associatedtype Root
    func validate(_ model: Root) -> Bool
}

public class KPValidator<Model>: KPValidation {

    public func validate(_ model: Model) -> Bool {
        return _validate(model)
    }
    
    private var _validate: ((Model) -> Bool)!
    
    public init(_ validators: [KeyPath<Model, Bool>], closure: @escaping () -> ()) {
        _validate = { model in
            for i in validators where model[keyPath: i] == false {
                closure()
                return false
            }
            
            return true
        }
    }
}

extension Array where Element: KPValidation {
    func validate(with model: Element.Root) -> Element.Root? {
        for i in self where i.validate(model) == false {
            return nil
        }
        
        return model
    }
}
