//
//  KPTwoWayBinding.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

public class KPTwoWayBinding<Model>: KPBinding<Model> {
    
    var addTargetWithActionForEvent: ((Any?, Selector) -> ())!
    
    var viewUpdateModel:             ((inout Model) -> ())!
    
    public init<V: KPTwoWayView>(_ view: V,
                              _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>,
                              _ event: UIControl.Event,
                              _ mKeyPath: WritableKeyPath<Model, V.Value>) {
        super.init()
        
        viewUpdateModel = { [weak view] in
            guard let view = view else { return }
            
            $0[keyPath: mKeyPath] = view[keyPath: vKeyPath]
            
            print("<-> : view#\(view.id) \(view[keyPath: vKeyPath]) -> m")
        }
        
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
            
            print("<-> : add target \(view.id)")
        }
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateModelAndView = { [weak view] in
            guard let value = $1 as? V.Value else {
                assert(false, "Type is \(type(of: $1)), but expected \(V.Value.self)")
                return
            }
        
            $0[keyPath: mKeyPath] = value
            
            guard let view = view else { return }
            view[keyPath: vKeyPath] = value
            
            print("<-> : m=", value)
            print("<-> : view#\(view.id) <-", value)
        }

        modelUpdateView = { [weak view] in
            guard let view = view else { return }
            
            view[keyPath: vKeyPath] = $0[keyPath: mKeyPath]
            
            print("<-> : view#\(view.id) <-", $0[keyPath: mKeyPath])
        }
        
    }

    public init<V: UIControl, Value>(_ view: V,
                              _ event: UIControl.Event,
                              _ mKeyPath: WritableKeyPath<Model, Value>,
                              _ viewAdapter: @escaping (V, Value) -> (),
                              _ valueBuilder: @escaping (V, Model) -> Value) {
        
        super.init()
        
        viewUpdateModel = { [weak view] in
            guard let view = view else { return }
            
            $0[keyPath: mKeyPath] = valueBuilder(view, $0)
            
            print("<~> : view#\(view.id) \(valueBuilder(view, $0)) ~> m")
        }
        
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
            
            print("<~> : add target \(view.id)")
        }
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateModelAndView = { [weak view] in
            guard let value = $1 as? Value else {
                assert(false, "Type is \(type(of: $1)), but expected \(V.self)")
                return
            }
            $0[keyPath: mKeyPath] = value
            
            guard let view = view else { return }
            viewAdapter(view, value)
            
            print("<~> : m=", value)
            print("<~> : view#\(view.id) <~", value)
        }

        modelUpdateView = { [weak view] in
            guard let view = view else { return }
            
            viewAdapter(view, $0[keyPath: mKeyPath])
            
            print("<~> : view#\(view.id) <~", $0[keyPath: mKeyPath])
        }
        
    }
}


infix operator <->

public extension KPTwoWayView {
    
    static func <-> <Model>(view: Self, mKeyPath: WritableKeyPath<Model, Self.Value>) -> KPBinding<Model> {
        KPTwoWayBinding(view, Self.keyPath, Self.twoWayEvent, mKeyPath)
    }
}


infix operator <~>

public typealias KPTwoWayTriple<V: KPTwoWayView, Model, Value> =
    (WritableKeyPath<Model, Value>, (V, Value) -> (), (V, Model) -> Value)

public extension KPTwoWayView {
   
    static func <~> <Model, Value>(view: Self, triple: KPTwoWayTriple<Self, Model, Value>) -> KPBinding<Model> {
        KPTwoWayBinding(view, Self.twoWayEvent, triple.0, triple.1, triple.2)
    }
}
