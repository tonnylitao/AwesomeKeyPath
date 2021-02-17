//
//  ViewController.swift
//  AwesomeKeyPath
//
//  Created by tonnylitao on 07/14/2020.
//  Copyright (c) 2020 tonnylitao. All rights reserved.
//

import UIKit
import AwesomeKeyPath

extension User: KPValidation {}

class ViewController: UIViewController {
    
    @IBOutlet weak var groupNameLbl:     UILabel!
    @IBOutlet weak var nameField:        UITextField!
    @IBOutlet weak var emailField:       UITextField!
    
    @IBOutlet weak var ageLbl:           UILabel!
    @IBOutlet weak var ageSteper:        UIStepper!
    
    @IBOutlet weak var activitySlider:   UISlider!
    @IBOutlet weak var likeKiwiSwitcher: UISwitch!
    
    @IBOutlet weak var travelBtn:        UIButton!
    @IBOutlet weak var hikingBtn:        UIButton!
    
    
    lazy var userBinding: KPDataBinding<User> = {
        let binding = KPDataBinding<User>()
        
        //one way bind
        binding.oneWayBind(\.groupName, groupNameLbl)
        //binding.bind(\.groupName => groupNameLbl)
        
        binding.oneWayBind(\.name, travelBtn, { view, value in
            view.setTitle(value, for: .normal)
        })
        
        binding.oneWayBind(\.age, ageLbl, { view, value in
            view.text = "Your Age: \(value)"
        })
        
        
        //two way bind
        binding.twoWayBind(\.name, nameField)
            .twoWayBind(\.email, emailField)
            .twoWayBind(\.activity, activitySlider)
            .twoWayBind(\.likeKiwi, likeKiwiSwitcher)
            .twoWayBind(\.travel, travelBtn)
            .twoWayBind(\.hiking, hikingBtn)

//        binding.bind(\.name <=> nameField)
//            .bind(\.email <=> emailField)
//            .bind(\.activity <=> activitySlider)
//            .bind(\.likeKiwi <=> likeKiwiSwitcher)
//            .bind(\.travel <=> travelBtn)
//            .bind(\.hiking <=> hikingBtn)

        binding.twoWayBind(\.age, ageSteper, formatter: { view, modal in
            Int(view.value)
        }, render: { view, value in
            view.value = Double(value)
        })
        
        return binding
    }()
    
    override func viewDidLoad() {
        userBinding.model = User(groupName: "Save NZ Animals Group 1", name: "Tonny")
    }
    
    @IBAction func updateProperties(_ sender: Any) {
        userBinding.update(\.name, with: .random)
        userBinding.update(\.age, with: Int.random(in: 0...100))
        userBinding.update(\.activity, with: Float.random(in: activitySlider.minimumValue...activitySlider.maximumValue))
    }
    
    @IBAction func reset(_ sender: Any) {
        userBinding.model = .random
    }
    
    @IBAction func submit(_ sender: Any) {
        assertBinding()
        
        let model = userBinding.model!
        debugPrint(model)
        
        guard model.validate(\.name.isSome, \.name!.isNotEmpty) else {
            nameField.becomeFirstResponder()
            return
        }
        
        guard model.validate(\.email.isSome, \.email!.isEmail, { (5...20).contains($0.email!.count) }) else {
            emailField.becomeFirstResponder()
            return
        }
        
        //...
    }
    
}

extension ViewController {
    
    func assertBinding() {
        let data = userBinding.model!
        
        assert(groupNameLbl.text == data.groupName)
        
        //set UITextField text nil, but still get ""
        assert(nameField.text == data.name || (nameField.text == "" && data.name == nil))
        assert(emailField.text == data.email || (emailField.text == "" && data.email == nil))
        
        assert(activitySlider.value == data.activity)
        assert(likeKiwiSwitcher.isOn == data.likeKiwi)
        assert(travelBtn.isSelected == data.travel)
        assert(hikingBtn.isSelected == data.hiking)
        
        assert(Int(ageSteper.value) == data.age)
    }
}
