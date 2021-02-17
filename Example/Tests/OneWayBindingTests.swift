//
//  OneWayBindingTests.swift
//  AwesomeKeyPath_Tests
//
//  Created by Tonny on 20/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import XCTest
import AwesomeKeyPath

class OneWayBindingTests: XCTestCase {
    
    var viewModel: KPDataBindingViewModel<User>!

    override func setUpWithError() throws {
        viewModel = KPDataBindingViewModel<User>()
    }

    override func tearDownWithError() throws {}

    func testInitial() throws {
        // Arrange
        let lbl = UILabel()
        let field = UITextField()
        let btn = UIButton()
        
        // Action
        viewModel.bind(User(), [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(field, \.text, \.email),
            KPOneWayBinding(btn, \.isSelected, \.likeKiwi)
        ])
        
        // Assert
        XCTAssertNotNil(viewModel.model)
        
        XCTAssertNil(viewModel.model.name)
        XCTAssertNil(lbl.text)
        
        XCTAssertNil(viewModel.model.email)
        XCTAssertEqual(field.text, UITextField().text)
        
        XCTAssertFalse(viewModel.model.likeKiwi)
        XCTAssertFalse(btn.isSelected)
    }
    
    func testInitialWithData() throws {
        // Arrange
        let lbl = UILabel()
        let field = UITextField()
        
        // Action
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(field, \.text, \.email)
        ])
        
        // Assert
        XCTAssertEqual(lbl.text, viewModel.model.name)
        XCTAssertEqual(field.text, viewModel.model.email)
    }
    
    func testUpdate() throws {
        // Arrange
        let lbl = UILabel()
        let field = UITextField()
        
        // Action
        viewModel.bind(User(), [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(field, \.text, \.email)
        ])
        
        let text = String.random
        
        viewModel.update(\.name, with: text)
        
        // Assert
        XCTAssertEqual(viewModel.model.name, text)
        XCTAssertEqual(lbl.text, text)
        
        // Action & Assert
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertNil(lbl.text)
        
        // Action & Assert
        viewModel.update(\.email, with: text)
        XCTAssertEqual(viewModel.model.email, text)
        XCTAssertEqual(field.text, text)
        
        // Action & Assert
        viewModel.update(\.email, with: nil)
        XCTAssertNil(viewModel.model.email)
        XCTAssertEqual(field.text, UITextField().text)
    }
    
    func testUnbind() throws {
        // Arrange
        let lbl = UILabel()
        
        // Action
        viewModel.bind(User(), [
            lbl     <- \.name
        ])
        viewModel.unbind(\.name)
        
        // Assert
        XCTAssertFalse(viewModel.update(\.name, with: String.random))
    }
    
    func testOneFieldToManyView() throws {
        // Arrange
        let view1 = UILabel()
        let view2 = UILabel()
        let view3 = UITextField()
        
        // Action
        viewModel.bind(User.random, [
            KPOneWayBinding(view1, \.text, \.name),
            KPOneWayBinding(view2, \.text, \.name),
            KPOneWayBinding(view3, \.text, \.name)
        ])
        
        // Assert
        XCTAssertEqual(view1.text, viewModel.model.name)
        XCTAssertEqual(view2.text, viewModel.model.name)
        XCTAssertEqual(view3.text, viewModel.model.name)
        
        // Action
        let text = String.random
        viewModel.update(\.name, with: text)
        
        // Assert
        XCTAssertEqual(viewModel.model.name, text)
        XCTAssertEqual(view1.text, text)
        XCTAssertEqual(view2.text, text)
        XCTAssertEqual(view3.text, text)
        
        // Action
        viewModel.update(\.name, with: nil)
        
        // Assert
        XCTAssertNil(viewModel.model.name)
        XCTAssertNil(view1.text)
        XCTAssertNil(view2.text)
        XCTAssertEqual(view3.text, UITextField().text)
    }
    
    func testManyFieldToOneView() throws {
        // Arrange
        let lbl = UILabel()
        
        // Action
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(lbl, \.text, \.email),
            KPOneWayBinding(lbl, \.text, \.groupName)
        ])
        
        // Assert
        XCTAssertEqual(lbl.text, viewModel.model.groupName)
        
        // Action & Assert
        viewModel.update(\.name, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.name)
        
        // Action & Assert
        viewModel.update(\.email, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.email)
        
        // Action & Assert
        viewModel.update(\.groupName, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.groupName)
    }
    
    func testOneFormat() throws {
        // Arrange
        let text = String.random
        let lbl = UILabel()
        
        // Action
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \User.name, { $0.text = ($1 ?? "") + text })
        ])
        
        // Assert
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text)
        
        // Action
        let text1 = String.random
        
        // Action & Assert
        viewModel.update(\.name, with: text1)
        XCTAssertEqual(viewModel.model.name, text1)
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text)
        
        // Action & Assert
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertEqual(lbl.text, text)
    }
    
    func testMultileFormat() throws {
        // Arrange
        let text1 = String.random
        let text2 = String.random
        
        let lbl = UILabel()
        let field = UITextField()
        
        // Action
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \User.name, { $0.text = ($1 ?? "") + text1 }),
            KPOneWayBinding(field, \User.name, { $0.text = ($1 ?? "") + text2 })
        ])
        
        // Assert
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text1)
        XCTAssertEqual(field.text, (viewModel.model.name ?? "") + text2)
        
        // Action & Assert
        let text = String.random
        viewModel.update(\.name, with: text)
        XCTAssertEqual(viewModel.model.name, text)
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text1)
        XCTAssertEqual(field.text, (viewModel.model.name ?? "") + text2)
        
        // Action & Assert
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertEqual(lbl.text, text1)
        XCTAssertEqual(field.text, text2)
    }
    
    func testOtherFormat() throws {
        // Arrange
        let lbl = UILabel()
        
        // Action
        viewModel.bind(User(), [
            KPOneWayBinding(lbl, \User.name, { $0.layer.cornerRadius = CGFloat(Float($1 ?? "0") ?? 0) })
        ])
        
        // Assert
        XCTAssertEqual(lbl.layer.cornerRadius, 0)
        
        // Action & Assert
        let random = CGFloat.random(in: 0...1000)
        viewModel.update(\.name, with: "\(random)")
        XCTAssertEqual(viewModel.model.name, "\(random)")
        XCTAssertEqual(lbl.layer.cornerRadius, CGFloat(Float("\(random)") ?? 0))
        
        // Action & Assert
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertEqual(lbl.layer.cornerRadius, 0)
    }
}
