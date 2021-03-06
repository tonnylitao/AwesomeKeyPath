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
    var removeTargetWithActionForEvent: ((Any?, Selector) -> ())!
    
    var viewUpdateModel:             ((inout Model) -> (Bool))!
    
    public init<V: KPTwoWayView>(_ mKeyPath: WritableKeyPath<Model, V.Value>,
                                 _ view: V,
                                 _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>,
                                 _ event: UIControl.Event) {
        super.init()
        
        viewUpdateModel = { [weak view] in
            guard let view = view else { return false }
            
            $0[keyPath: mKeyPath] = view[keyPath: vKeyPath]
            
            print("<=> : view#\(view.id) \(view[keyPath: vKeyPath]) -> m")
            return true
        }
        
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
            
            print("<=> : add target \(view.id)")
        }
        
        removeTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }

            view.removeTarget($0, action: $1, for: event)

            print("<=> : remove target \(view.id)")
        }
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateViewWithModel = { [weak view] in
            guard let view = view else { return false }
            
            view[keyPath: vKeyPath] = $0[keyPath: mKeyPath]
            
            print("<=> : view#\(view.id) <-", $0[keyPath: mKeyPath])
            return true
        }
        
    }
    
    public init<V: UIControl, Value>(_ mKeyPath: WritableKeyPath<Model, Value>,
                                     _ view: V,
                                     _ event: UIControl.Event,
                                     _ viewAdapter: @escaping (V, Value) -> (),
                                     _ valueBuilder: @escaping (V, Model) -> Value) {
        super.init()
        
        viewUpdateModel = { [weak view] in
            guard let view = view else { return false }
            
            $0[keyPath: mKeyPath] = valueBuilder(view, $0)
            
            print("<~> : view#\(view.id) \(valueBuilder(view, $0)) ~> m")
            return true
        }
        
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
            
            print("<~> : add target \(view.id)")
        }
        
        removeTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }

            view.removeTarget($0, action: $1, for: event)

            print("<~> : remove target \(view.id)")
        }
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateViewWithModel = { [weak view] in
            guard let view = view else { return false }
            
            viewAdapter(view, $0[keyPath: mKeyPath])
            
            print("<~> : view#\(view.id) <~", $0[keyPath: mKeyPath])
            return true
        }
        
    }
}


infix operator <=>

public extension KPTwoWayView {
    
    static func <=> <Model>(mKeyPath: WritableKeyPath<Model, Self.Value>, view: Self) -> KPTwoWayBinding<Model> {
        KPTwoWayBinding(mKeyPath, view, Self.keyPath, Self.twoWayEvent)
    }
}
