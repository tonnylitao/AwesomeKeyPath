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
        let lbl = UILabel()
        let field = UITextField()
        let btn = UIButton()
        
        viewModel.bind(User(), [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(field, \.text, \.email),
            KPOneWayBinding(btn, \.isSelected, \.likeKiwi)
        ])
        
        XCTAssertNotNil(viewModel.model)
        
        XCTAssertNil(viewModel.model.name)
        XCTAssertNil(lbl.text)
        
        XCTAssertNil(viewModel.model.email)
        XCTAssertEqual(field.text, UITextField().text)
        
        XCTAssertFalse(viewModel.model.likeKiwi)
        XCTAssertFalse(btn.isSelected)
    }
    
    func testInitialWithData() throws {
        let lbl = UILabel()
        let field = UITextField()
        
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(field, \.text, \.email)
        ])
        
        XCTAssertEqual(lbl.text, viewModel.model.name)
        XCTAssertEqual(field.text, viewModel.model.email)
    }
    
    func testUpdate() throws {
        let lbl = UILabel()
        let field = UITextField()
        
        viewModel.bind(User(), [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(field, \.text, \.email)
        ])
        
        let text = String.random
        
        viewModel.update(\.name, with: text)
        XCTAssertEqual(viewModel.model.name, text)
        XCTAssertEqual(lbl.text, text)
        
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertNil(lbl.text)
        
        //
        viewModel.update(\.email, with: text)
        XCTAssertEqual(viewModel.model.email, text)
        XCTAssertEqual(field.text, text)
        
        viewModel.update(\.email, with: nil)
        XCTAssertNil(viewModel.model.email)
        XCTAssertEqual(field.text, UITextField().text)
    }
    
    func testUnbind() throws {
        let lbl = UILabel()
        
        viewModel.bind(User(), [
            lbl     <- \.name
        ])
        
        viewModel.unbind(\.name)
        XCTAssertFalse(viewModel.update(\.name, with: String.random))
    }
    
    func testOneFieldToManyView() throws {
        let view1 = UILabel()
        let view2 = UILabel()
        let view3 = UITextField()
        
        viewModel.bind(User.random, [
            KPOneWayBinding(view1, \.text, \.name),
            KPOneWayBinding(view2, \.text, \.name),
            KPOneWayBinding(view3, \.text, \.name)
        ])
        
        XCTAssertEqual(view1.text, viewModel.model.name)
        XCTAssertEqual(view2.text, viewModel.model.name)
        XCTAssertEqual(view3.text, viewModel.model.name)
        
        let text = String.random
        viewModel.update(\.name, with: text)
        XCTAssertEqual(viewModel.model.name, text)
        XCTAssertEqual(view1.text, text)
        XCTAssertEqual(view2.text, text)
        XCTAssertEqual(view3.text, text)
        
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertNil(view1.text)
        XCTAssertNil(view2.text)
        XCTAssertEqual(view3.text, UITextField().text)
    }
    
    func testManyFieldToOneView() throws {
        let lbl = UILabel()
        
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \.text, \.name),
            KPOneWayBinding(lbl, \.text, \.email),
            KPOneWayBinding(lbl, \.text, \.groupName)
        ])
        
        XCTAssertEqual(lbl.text, viewModel.model.groupName)
        
        viewModel.update(\.name, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.name)
        
        viewModel.update(\.email, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.email)
        
        viewModel.update(\.groupName, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.groupName)
    }
    
    func testOneFormat() throws {
        let text = String.random
        
        let lbl = UILabel()
        
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \User.name, { $0.text = ($1 ?? "") + text })
        ])
        
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text)
        
        let text1 = String.random
        viewModel.update(\.name, with: text1)
        XCTAssertEqual(viewModel.model.name, text1)
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text)
        
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertEqual(lbl.text, text)
    }
    
    func testMultileFormat() throws {
        let text1 = String.random
        let text2 = String.random
        
        let lbl = UILabel()
        let field = UITextField()
        
        viewModel.bind(User.random, [
            KPOneWayBinding(lbl, \User.name, { $0.text = ($1 ?? "") + text1 }),
            KPOneWayBinding(field, \User.name, { $0.text = ($1 ?? "") + text2 })
        ])
        
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text1)
        XCTAssertEqual(field.text, (viewModel.model.name ?? "") + text2)
        
        let text = String.random
        viewModel.update(\.name, with: text)
        XCTAssertEqual(viewModel.model.name, text)
        XCTAssertEqual(lbl.text, (viewModel.model.name ?? "") + text1)
        XCTAssertEqual(field.text, (viewModel.model.name ?? "") + text2)
        
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertEqual(lbl.text, text1)
        XCTAssertEqual(field.text, text2)
    }
    
    func testOtherFormat() throws {
        let lbl = UILabel()
        
        viewModel.bind(User(), [
            KPOneWayBinding(lbl, \User.name, { $0.layer.cornerRadius = CGFloat(Float($1 ?? "0") ?? 0) })
        ])
        
        XCTAssertEqual(lbl.layer.cornerRadius, 0)
        
        let random = CGFloat.random(in: 0...1000)
        viewModel.update(\.name, with: "\(random)")
        XCTAssertEqual(viewModel.model.name, "\(random)")
        XCTAssertEqual(lbl.layer.cornerRadius, CGFloat(Float("\(random)") ?? 0))
        
        viewModel.update(\.name, with: nil)
        XCTAssertNil(viewModel.model.name)
        XCTAssertEqual(lbl.layer.cornerRadius, 0)
    }
}
