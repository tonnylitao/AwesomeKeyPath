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
    
    var viewModel: KPDataBinding<User>!

    override func setUpWithError() throws {
        viewModel = KPDataBinding<User>()
        viewModel.model = User()
    }

    override func tearDownWithError() throws {}

    func testInitial() throws {
        let lbl = UILabel()
        let field = UITextField()
        let btn = UIButton()
        
        viewModel.oneWayBind(\.name, lbl)
            .oneWayBind(\.email, field)
            .oneWayBind(\.likeKiwi, btn)
        
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
        
        
        viewModel.model = User.random
        viewModel.oneWayBind(\.name, lbl)
            .oneWayBind(\.email, field)
        
        XCTAssertEqual(lbl.text, viewModel.model.name)
        XCTAssertEqual(field.text, viewModel.model.email)
    }
    
    func testUpdate() throws {
        let lbl = UILabel()
        let field = UITextField()
        
        viewModel.oneWayBind(\.name, lbl)
            .oneWayBind(\.email, field)
        
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
        let lbl1 = UILabel()
        let lbl2 = UILabel()
        
        viewModel.bind(\.name => lbl1)
            .bind(\.name => lbl2)
        
        viewModel.unbind(\.name)
        XCTAssertFalse(viewModel.update(\.name, with: String.random))
    }
    
    func testOneFieldToManyView() throws {
        let view1 = UILabel()
        let view2 = UILabel()
        let view3 = UITextField()
        
        viewModel.bind(\.name => view1)
            .bind(\.name => view2)
            .bind(\.name => view3)
        viewModel.model = User.random
        
        
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
        
        viewModel.bind(\.name => lbl)
            .bind(\.email => lbl)
            .bind(\.groupName => lbl)
        viewModel.model = User.random
        
        XCTAssertEqual(lbl.text, viewModel.model.groupName)
        
        viewModel.update(\.name, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.name)
        
        viewModel.update(\.email, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.email)
        
        viewModel.update(\.groupName, with: String.random)
        XCTAssertEqual(lbl.text, viewModel.model.groupName)
    }
}
