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
    
    
    lazy var userBinding: KPDataBinding<User> = KPDataBinding(User(groupName: "Save NZ Animals Group 1", name: "Tonny"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    private func setupBinding() {
        /*
         One way bind
         */
        userBinding.oneWayBind(\.groupName, groupNameLbl)
        
        //same as
        //binding.bind(\.groupName => groupNameLbl)
        
        //customised view render
        userBinding.oneWayBind(\.name, travelBtn, { view, value in
            view.setTitle(value, for: .normal)
        })
        
        //customised view render
        userBinding.oneWayBind(\.age, ageLbl, { view, value in
            view.text = "Your Age: \(value)"
        })
        
        
        /*
         Two way bind
         */
        userBinding.twoWayBind(\.name, nameField)
            .twoWayBind(\.email, emailField)
            .twoWayBind(\.activity, activitySlider)
            .twoWayBind(\.likeKiwi, likeKiwiSwitcher)
            .twoWayBind(\.travel, travelBtn)
            .twoWayBind(\.hiking, hikingBtn)
        
        /*
         same as
         
         binding.bind(\.name <=> nameField)
         .bind(\.email <=> emailField)
         .bind(\.activity <=> activitySlider)
         .bind(\.likeKiwi <=> likeKiwiSwitcher)
         .bind(\.travel <=> travelBtn)
         .bind(\.hiking <=> hikingBtn)
         */
        
        //data formatter and customised view render
        userBinding.twoWayBind(\.age, ageSteper, formatter: { view, modal in
            Int(view.value)
        }, render: { view, value in
            view.value = Double(value)
        })
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
        let model = userBinding.model!
        debugPrint(model)
        
        assert(groupNameLbl.text == model.groupName)
        
        //set UITextField text nil, but still get ""
        assert(nameField.text == model.name || (nameField.text == "" && model.name == nil))
        assert(emailField.text == model.email || (emailField.text == "" && model.email == nil))
        
        assert(activitySlider.value == model.activity)
        assert(likeKiwiSwitcher.isOn == model.likeKiwi)
        assert(travelBtn.isSelected == model.travel)
        assert(hikingBtn.isSelected == model.hiking)
        
        assert(Int(ageSteper.value) == model.age)
        
        
        
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
