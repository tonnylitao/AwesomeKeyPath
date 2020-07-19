//
//  ViewController.swift
//  AwesomeKeyPath
//
//  Created by tonnylitao on 07/14/2020.
//  Copyright (c) 2020 tonnylitao. All rights reserved.
//

import UIKit
import AwesomeKeyPath

struct IndicatorStatus {
    var isLoading = false
}

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
    @IBOutlet weak var readingBtn:       UIButton!
    
    @IBOutlet weak var indicator:        UIActivityIndicatorView!
    
    
    lazy var userViewModel = KPDataBindingViewModel<User>()
    
    lazy var loadingViewModel = KPDataBindingViewModel<IndicatorStatus>()
    
    override func viewDidLoad() {
        
        KPLog.log(true)
        
        loadingViewModel.bind(IndicatorStatus(), [
            indicator <~ (\IndicatorStatus.isLoading, {
                if $1 {
                    $0.startAnimating()
                }else {
                    $0.stopAnimating()
                }
            })
        ])
        
        
        let initialData = User(groupName: "Save NZ Animals Group 1", name: "Tonny")
    
        userViewModel.bind(initialData, [
            groupNameLbl     <-  \.groupName,
            
            nameField        <-> \.name,
            emailField       <-> \.email,
            activitySlider   <-> \.activity,
            likeKiwiSwitcher <-> \.likeKiwi,
            travelBtn        <-> \.travel,
            hikingBtn        <-> \.hiking,
            readingBtn       <-> \.reading,
            
            travelBtn        <~  (\.name, { $0.setTitle($1, for: .normal) }),
            ageLbl           <~  (\.age,  { $0.text = "Your Age: \($1)" }),
            
            ageSteper        <~> (\.age,  { $0.value = Double($1) }, { view, _ in Int(view.value) }),
        ])
    }
    
    @IBAction func updateProperties(_ sender: Any) {
        userViewModel.update(\.name, with: .random)
        userViewModel.update(\.age, with: Int.random(in: 0...100))
        userViewModel.update(\.activity, with: Float.random(in: activitySlider.minimumValue...activitySlider.maximumValue))
    }
    
    @IBAction func reset(_ sender: Any) {
        userViewModel.updateWith(.random)
    }
    
    @IBAction func submit(_ sender: Any) {
        assertBinding()
        
        let model = userViewModel.model!
        print(model)
        
        guard model.validate(\.name.isSome, \.name!.isNotEmpty) else {
            nameField.becomeFirstResponder()
            return
        }
        
        guard model.validate(\.email.isSome, \.email!.isEmail, { $0.email!.count > 5 }) else {
            emailField.becomeFirstResponder()
            return
        }
        
        if !loadingViewModel.model.isLoading {

            loadingViewModel.update(\.isLoading, with: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.loadingViewModel.update(\.isLoading, with: false)
            }
        }
    }
    
}

extension ViewController {

    func assertBinding() {
        let data = userViewModel.model
        
        assert(groupNameLbl.text == data?.groupName)
        
        //set UITextField text nil, but still get ""
        assert(nameField.text == data?.name || (nameField.text == "" && data?.name == nil))
        assert(emailField.text == data?.email || (emailField.text == "" && data?.email == nil))
        
        assert(activitySlider.value == data?.activity)
        assert(likeKiwiSwitcher.isOn == data?.likeKiwi)
        assert(travelBtn.isSelected == data?.travel)
        assert(hikingBtn.isSelected == data?.hiking)
        assert(readingBtn.isSelected == data?.reading)
        
        assert(Int(ageSteper.value) == data?.age)
    }
}
