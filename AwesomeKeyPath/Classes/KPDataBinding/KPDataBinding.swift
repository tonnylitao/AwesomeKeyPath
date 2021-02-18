//
// KPDataBinding.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation
import UIKit


public class KPDataBinding<Model> {
    
    lazy private var _bindings = [KPBinding<Model>]()
//    lazy private var _twoWaybindings = [ViewID: [KPTwoWayBinding<Model>]]()
    
    public var model: Model! {
        didSet {
            _bindings.forEach {
                $0.updateViewWithModel(model)
            }
        }
    }
    
    public init(_ model: Model? = nil) {
        self.model = model
    }
    
    @objc private func viewChanged(control: UIControl) {
        (control as? KPTwoWayEventReceiver)?.handleEvent()
        
        /*
         two way binding first
         */
        var affectedKeyPaths = Set<AnyKeyPath>()
        
        _bindings
            .filter { $0.id == control.id }
            .compactMap { $0 as? KPTwoWayBinding }
            .forEach {
                $0.viewUpdateModel(&model)
                affectedKeyPaths.insert($0.modelKeyPath)
            }
        
        /*
         one way binding later
         */
        _bindings
            .filter { affectedKeyPaths.contains($0.modelKeyPath) }
            .compactMap { $0 as? KPOneWayBinding }
            .forEach { $0.updateViewWithModel(model) }
        
        print(model as Any)
    }
}

extension KPDataBinding {
    
    @discardableResult
    public func oneWayBind<V: KPOneWayView>(_ mKeyPath: KeyPath<Model, V.Value>,
                                            _ view: V) -> Self where V.View == V {
        let binding = KPOneWayBinding(mKeyPath, view, V.keyPath)
        return bind(binding)
    }
    
    @discardableResult
    public func oneWayBind<V: UIView, Value>(_ mKeyPath: KeyPath<Model, Value>,
                                             _ view: V,
                                             _ render: @escaping (V, Value) -> ()) -> Self {
        let binding = KPOneWayBinding(mKeyPath, view, render)
        return bind(binding)
    }
    
    @discardableResult
    public func twoWayBind<V: KPTwoWayView>(_ mKeyPath: WritableKeyPath<Model, V.Value>,
                                            _ view: V) -> Self {
        let binding = KPTwoWayBinding(mKeyPath, view, V.keyPath, V.twoWayEvent)
        return bind(binding)
    }
    
    @discardableResult
    public func twoWayBind<V: KPTwoWayView, Value>(_ mKeyPath: WritableKeyPath<Model, Value>,
                                             _ view: V,
                                             formatter: @escaping (V, Model) -> Value,
                                             render: @escaping (V, Value) -> ()) -> Self {
        let binding = KPTwoWayBinding(mKeyPath, view, V.twoWayEvent, render, formatter)
        return bind(binding)
    }
    
    
    @discardableResult
    public func bind(_ binding: KPBinding<Model>) -> Self {
        _bindings.append(binding)
        if let m = model {
            binding.updateViewWithModel(m)
        }
        
        if let twoWayBinding = binding as? KPTwoWayBinding<Model> {
            assert(binding.id > 0)
            
            twoWayBinding.addTargetWithActionForEvent(self, #selector(viewChanged))
        }
        
        return self
    }
    
    @discardableResult
    public func bind(_ bindings: [KPBinding<Model>]) -> Self {
        bindings.forEach {
            bind($0)
        }
        
        return self
    }
}


extension KPDataBinding {
    
    @discardableResult
    public func update<Value>(_ keyPath: WritableKeyPath<Model, Value>, with value: Value) -> Bool {
        model[keyPath: keyPath] = value
        
        let bindings = _bindings.filter({ $0.modelKeyPath == keyPath })
        bindings.forEach {
            $0.updateViewWithModel(model)
        }
        
        return !bindings.isEmpty
    }
}

extension KPDataBinding {
    
    public func unbind<Value>(_ keyPath: KeyPath<Model, Value>) {
        _bindings
            .filter { $0.modelKeyPath == keyPath }
            .compactMap { $0 as? KPTwoWayBinding }
            .forEach { $0.removeTargetWithActionForEvent(self, #selector(viewChanged)) }
        
        _bindings.removeAll { $0.modelKeyPath == keyPath }
    }
}
