//
//  KPBinding.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation
import UIKit

typealias ViewID = Int
extension UIView {
    var id: ViewID { tag }
}

public class KPBinding<Model> {

    var modelKeyPath: AnyKeyPath!
    var id: ViewID!

    var updateViewWithModel: ((Model) -> (Bool))!
}
