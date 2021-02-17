//
//  OneWayTests.swift
//  AwesomeKeyPath_Tests
//
//  Created by Tonny on 20/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import XCTest
import AwesomeKeyPath

class OneWayOperatorTests: XCTestCase {
    
    var binding: KPDataBinding<User>!

    override func setUpWithError() throws {
        binding = KPDataBinding(User())
    }

    override func tearDownWithError() throws {}

    func testInitial() throws {
        let lbl = UILabel()
        let field = UITextField()
        let btn = UIButton()
        
        binding.oneWayBind(\.name, lbl)
            .oneWayBind(\.email, field)
            .oneWayBind(\.likeKiwi, btn)
        
        XCTAssertNotNil(binding.model)
        
        XCTAssertNil(binding.model.name)
        XCTAssertNil(lbl.text)
        
        XCTAssertNil(binding.model.email)
        XCTAssertEqual(field.text, UITextField().text)
        
        XCTAssertFalse(binding.model.likeKiwi)
        XCTAssertFalse(btn.isSelected)
    }
    
    func testInitialWithData() throws {
        let lbl = UILabel()
        let field = UITextField()
        
        
        binding.oneWayBind(\.name, lbl)
            .oneWayBind(\.email, field)
        binding.model = .random
        
        XCTAssertEqual(lbl.text, binding.model.name)
        XCTAssertEqual(field.text, binding.model.email)
    }
    
    func testUpdate() throws {
        let lbl = UILabel()
        let field = UITextField()
        
        binding.oneWayBind(\.name, lbl)
            .oneWayBind(\.email, field)
        
        let text = String.random
        
        binding.update(\.name, with: text)
        XCTAssertEqual(binding.model.name, text)
        XCTAssertEqual(lbl.text, text)
        
        binding.update(\.name, with: nil)
        XCTAssertNil(binding.model.name)
        XCTAssertNil(lbl.text)
        
        //
        binding.update(\.email, with: text)
        XCTAssertEqual(binding.model.email, text)
        XCTAssertEqual(field.text, text)
        
        binding.update(\.email, with: nil)
        XCTAssertNil(binding.model.email)
        XCTAssertEqual(field.text, UITextField().text)
    }
    
    func testUnbind() throws {
        let lbl1 = UILabel()
        let lbl2 = UILabel()
        
        binding.bind(\.name => lbl1)
            .bind(\.name => lbl2)
        
        binding.unbind(\.name)
        XCTAssertFalse(binding.update(\.name, with: String.random))
    }
    
    func testOneFieldToManyView() throws {
        let view1 = UILabel()
        let view2 = UILabel()
        let view3 = UITextField()
        
        binding.bind(\.name => view1)
            .bind(\.name => view2)
            .bind(\.name => view3)
        binding.model = .random
        
        
        XCTAssertEqual(view1.text, binding.model.name)
        XCTAssertEqual(view2.text, binding.model.name)
        XCTAssertEqual(view3.text, binding.model.name)
        
        let text = String.random
        binding.update(\.name, with: text)
        XCTAssertEqual(binding.model.name, text)
        XCTAssertEqual(view1.text, text)
        XCTAssertEqual(view2.text, text)
        XCTAssertEqual(view3.text, text)
        
        binding.update(\.name, with: nil)
        XCTAssertNil(binding.model.name)
        XCTAssertNil(view1.text)
        XCTAssertNil(view2.text)
        XCTAssertEqual(view3.text, UITextField().text)
    }
    
    func testManyFieldToOneView() throws {
        let lbl = UILabel()
        
        binding.bind(\.name => lbl)
            .bind(\.email => lbl)
            .bind(\.groupName => lbl)
        binding.model = .random
        
        XCTAssertEqual(lbl.text, binding.model.groupName)
        
        binding.update(\.name, with: String.random)
        XCTAssertEqual(lbl.text, binding.model.name)
        
        binding.update(\.email, with: String.random)
        XCTAssertEqual(lbl.text, binding.model.email)
        
        binding.update(\.groupName, with: String.random)
        XCTAssertEqual(lbl.text, binding.model.groupName)
    }
}
