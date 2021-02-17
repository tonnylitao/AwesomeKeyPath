//
//  KPOneWayBinding.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

public class KPOneWayBinding<Model>: KPBinding<Model> {
    
    public init<V: KPOneWayView>(_ mKeyPath: KeyPath<Model, V.Value>,
                                 _ view: V,
                                 _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>) where V.View == V {
        super.init()
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateViewWithModel = { [weak view] model in
            guard let view = view else { return }
            
            view[keyPath: vKeyPath] = model[keyPath: mKeyPath]
            
            print("<- : view#\(view.id) <-", model[keyPath: mKeyPath])
        }
    }
    
    public init<V: UIView, Value>(_ mKeyPath: KeyPath<Model, Value>,
                                  _ view: V,
                                  _ adapter: @escaping (V, Value) -> ()) {
        super.init()
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateViewWithModel = { [weak view] model in
            guard let view = view else { return }
            
            adapter(view, model[keyPath: mKeyPath])
            
            print("<~ : view#\(view.id) <~", model[keyPath: mKeyPath])
        }
    }
}


infix operator =>

public extension KPSelfOneWayView {
    
    /*
     let bindings = [
     \User.aString => uiLabel,
     \User.aString => uiTextField,
     \User.aBool   => uiButton,
     ]
     */
    
    static func => <Model>(mKeyPath: WritableKeyPath<Model, Self.Value>, view: Self) -> KPBinding<Model> {
        KPOneWayBinding(mKeyPath, view, Self.keyPath)
    }
}
