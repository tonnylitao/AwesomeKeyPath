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
            lbl     <- \.name,
            field   <- \.email,
            btn     <- \.likeKiwi
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
            lbl     <- \.name,
            field   <- \.email
        ])
        
        XCTAssertEqual(lbl.text, viewModel.model.name)
        XCTAssertEqual(field.text, viewModel.model.email)
    }
    
    func testUpdate() throws {
        let lbl = UILabel()
        let field = UITextField()
        
        viewModel.bind(User(), [
            lbl     <- \.name,
            field   <- \.email
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
        let lbl1 = UILabel()
        let lbl2 = UILabel()
        
        viewModel.bind(User(), [
            lbl1     <- \.name,
            lbl2     <- \.name
        ])
        
        viewModel.unbind(\.name)
        XCTAssertFalse(viewModel.update(\.name, with: String.random))
    }
    
    func testOneFieldToManyView() throws {
        let view1 = UILabel()
        let view2 = UILabel()
        let view3 = UITextField()
        
        viewModel.bind(User.random, [
            view1    <- \.name,
            view2    <- \.name,
            view3    <- \.name
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
            lbl    <- \.name,
            lbl    <- \.email,
            lbl    <- \.groupName
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
            lbl    <~ (\.name, { $0.text = ($1 ?? "") + text }),
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
            lbl    <~ (\.name, { $0.text = ($1 ?? "") + text1 }),
            field  <~ (\.name, { $0.text = ($1 ?? "") + text2 }),
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
}
