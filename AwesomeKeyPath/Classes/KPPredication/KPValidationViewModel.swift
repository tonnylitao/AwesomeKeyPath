//
//  KPBinding.swift
//  AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation
import UIKit


public struct KPValidationViewModel<Model> {
    lazy private var _validators = [KPValidator<Model>]()

    public init() {}
    
    @discardableResult
    public mutating func require(_ validators: KeyPath<Model, Bool>..., closure: @escaping () -> ()) -> Self {
        _validators.append(KPValidator(validators, closure: closure))
        return self
    }
    
    public mutating func add(_ validator: KPValidator<Model>) {
        _validators.append(validator)
    }

    public mutating func validate(with model: Model) -> Model? {
        _validators.validate(with: model)
    }
}


