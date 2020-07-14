//
//  KPOneWayView.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation
import UIKit

public protocol KPOneWayView: UIView {
    associatedtype View
    associatedtype Value

    static var keyPath: ReferenceWritableKeyPath<View, Value> { get }
}

public protocol KPSelfOneWayView: KPOneWayView where View == Self {}


extension UILabel: KPSelfOneWayView {
    
    public static let keyPath = \UILabel.text
}

extension UIImageView: KPSelfOneWayView {

    public static let keyPath = \UIImageView.image
}

extension UITextField: KPSelfOneWayView {

    public static let keyPath = \UITextField.text
}

extension UISwitch: KPSelfOneWayView {
    
    public static let keyPath = \UISwitch.isOn
}


extension UIButton: KPSelfOneWayView {
    
    public static let keyPath = \UIButton.isSelected
}


extension UISlider: KPSelfOneWayView {
    
    public static let keyPath = \UISlider.value
}


extension UIStepper: KPSelfOneWayView {
    
    public static let keyPath = \UIStepper.value
}
