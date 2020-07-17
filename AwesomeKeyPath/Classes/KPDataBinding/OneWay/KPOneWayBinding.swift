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
    
    public init<V: KPOneWayView>(_ view: V,
                                     _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>,
                                     _ mKeyPath: WritableKeyPath<Model, V.Value>) where V.View == V {
        super.init()
        
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
            
            print("<- : view#\(view.id) <-", $0)
        }

        modelUpdateView = { [weak view] in
            guard let view = view else { return }
            
            view[keyPath: vKeyPath] = $0[keyPath: mKeyPath]
            
            print("<- : view#\(view.id) <-", $0[keyPath: mKeyPath])
        }
    }
    
    public init<V: UIView, Value>(_ view: V,
                                     _ mKeyPath: KeyPath<Model, Value>,
                                     _ adapter: @escaping (V, Value) -> ()) {
        super.init()

        id = view.id
        modelKeyPath = mKeyPath

        updateModelAndView = { [weak view] in
            guard let value = $1 as? Value else {
                assert(false, "Type is \(type(of: $1)), but expected \(Value.self)")
                return
            }
            guard let writableKeyPath = mKeyPath as? WritableKeyPath<Model, Value> else {
                return
            }

            $0[keyPath: writableKeyPath] = value

            guard let view = view else { return }
            adapter(view, value)
            
            print("<~ : m=", value)
            print("<~ : view#\(view.id) <~", value)
        }

        modelUpdateView = { [weak view] in
            guard let view = view else { return }

            adapter(view, $0[keyPath: mKeyPath])
            
            print("<~ : view#\(view.id) <~", $0[keyPath: mKeyPath])
        }
    }
}


infix operator <-

public extension KPSelfOneWayView {
    static func <- <Model>(view: Self, mKeyPath: WritableKeyPath<Model, Self.Value>) -> KPBinding<Model> {
        KPOneWayBinding(view, Self.keyPath, mKeyPath)
    }
}


infix operator <~

public typealias KPTuple<V: UIView, Model, Value> = (KeyPath<Model, Value>, (V, Value) -> ())

public func <~ <V: UIView, Model, Value>(view: V, tuple: KPTuple<V, Model, Value>) -> KPBinding<Model> {
    KPOneWayBinding(view, tuple.0, tuple.1)
}
