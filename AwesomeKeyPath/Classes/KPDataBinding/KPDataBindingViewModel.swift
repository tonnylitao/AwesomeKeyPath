//
// KPDataBindingViewModelViewModel.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation
import UIKit

public class KPDataBindingViewModel<Model> {
    
    public private(set) var model: Model!
    
    lazy private var _bindings = [KPBinding<Model>]()
    lazy private var _twoWaybindings = [ViewID: [KPTwoWayBinding<Model>]]()
    
    public init() {}
    
    public func bind(_ model: Model, _ mapping: [KPBinding<Model>]) {
        self.model = model
        
        _bindings = mapping
        mapping.forEach { binding in
            
            binding.modelUpdateView(model)
            
            if let twoWayBinding = binding as? KPTwoWayBinding<Model> {
                twoWayBinding.addTargetWithActionForEvent(self, #selector(viewChanged))
                
                var array = _twoWaybindings[binding.id] ?? []
                array.append(twoWayBinding)
                _twoWaybindings[binding.id] = array
            }
        }
    }
    
    public func bind(_ binding: KPBinding<Model>) {
        assert(self.model != nil, "Please bind model first bind(_:_:)")
        
        _bindings.append(binding)
        binding.modelUpdateView(model)
        
        if let twoWayBinding = binding as? KPTwoWayBinding<Model> {
            twoWayBinding.addTargetWithActionForEvent(self, #selector(viewChanged))
            
            var array = _twoWaybindings[binding.id] ?? []
            array.append(twoWayBinding)
            _twoWaybindings[binding.id] = array
        }
    }
    
    public func unbind<Value>(_ keyPath: KeyPath<Model, Value>) {
        let keyPaths = _bindings.filter { $0.modelKeyPath == keyPath }
        
        _bindings.removeAll { $0.modelKeyPath == keyPath }
        keyPaths.forEach { _twoWaybindings.removeValue(forKey: $0.id) }
    }
    
    @objc private func viewChanged(control: UIControl) {
        
        (control as? KPTwoWayEventReceiver)?.handleEvent()
        
        /*
         two way binding first
        */
        if let twoWaybindings = _twoWaybindings[control.id] {
            twoWaybindings.forEach { $0.viewUpdateModel(&model) }
        }
        
        /*
         one way binding later
         */
        let keyPaths = _bindings
            .filter { $0.id == control.id }
            .reduce(into: [AnyKeyPath]()) {
                $0.append($1.modelKeyPath)
            }
        
        _bindings
            .filter { $0.id != control.id && keyPaths.contains($0.modelKeyPath) }
            .forEach { $0.modelUpdateView(model) }
        
        print(model as Any)
    }
}


extension KPDataBindingViewModel {
    
    public func update<Value>(_ keyPath: WritableKeyPath<Model, Value>, with value: Value) {
        
        let bindings = _bindings.filter({ $0.modelKeyPath == keyPath })
        bindings.forEach { $0.updateModelAndView(&model, value) }
    }
    
    public func updateWith(_ model: Model) {
        self.model = model
        
        _bindings.forEach { $0.modelUpdateView(model) }
    }
}
