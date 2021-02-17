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
    
    var binding: KPDataBinding<User>!

    override func setUpWithError() throws {
        binding = KPDataBinding(User())
    }

    override func tearDownWithError() throws {}

    func testInitial() throws {
        // Arrange
        let lbl = UILabel()
        lbl.tag = 1
        let field = UITextField()
        let btn = UIButton()
        
        // Action
        binding.bind(KPOneWayBinding(\.name, lbl, \.text))
        binding.bind(KPOneWayBinding(\.email, field, \.text))
        binding.bind(KPOneWayBinding(\.likeKiwi, btn, \.isSelected))
        
        // Assert
        XCTAssertNotNil(binding.model)

        XCTAssertNil(binding.model.name)
        XCTAssertNil(lbl.text)

        XCTAssertNil(binding.model.email)
        XCTAssertEqual(field.text, UITextField().text)

        XCTAssertFalse(binding.model.likeKiwi)
        XCTAssertFalse(btn.isSelected)
    }
    
    func testInitialWithData() throws {
        // Arrange
        let lbl = UILabel()
        let field = UITextField()
        
        // Action
        binding.bind(KPOneWayBinding(\.name, lbl, \.text))
        binding.bind(KPOneWayBinding(\.email, field, \.text))
        binding.model = .random
        
        // Assert
        XCTAssertEqual(lbl.text, binding.model.name)
        XCTAssertEqual(field.text, binding.model.email)
    }
    
    func testUpdate() throws {
        // Arrange
        let lbl = UILabel()
        let field = UITextField()
        
        // Action
        binding.bind(KPOneWayBinding(\.name, lbl, \.text))
        binding.bind(KPOneWayBinding(\.email, field, \.text))

        let text = String.random

        binding.update(\.name, with: text)

        // Assert
        XCTAssertEqual(binding.model.name, text)
        XCTAssertEqual(lbl.text, text)

        // Action & Assert
        binding.update(\.name, with: nil)
        XCTAssertNil(binding.model.name)
        XCTAssertNil(lbl.text)

        // Action & Assert
        binding.update(\.email, with: text)
        XCTAssertEqual(binding.model.email, text)
        XCTAssertEqual(field.text, text)

        // Action & Assert
        binding.update(\.email, with: nil)
        XCTAssertNil(binding.model.email)
        XCTAssertEqual(field.text, UITextField().text)
    }
    
    func testUnbind() throws {
        // Arrange
        let lbl = UILabel()
        
        // Action
        binding.bind( \.name => lbl )
        binding.unbind(\.name)
        
        // Assert
        XCTAssertFalse(binding.update(\.name, with: String.random))
    }
    
    func testOneFieldToManyView() throws {
        // Arrange
        let view1 = UILabel()
        let view2 = UILabel()
        let view3 = UITextField()
        
        // Action
        binding.bind([
            KPOneWayBinding(\.name, view1, \.text),
            KPOneWayBinding(\.name, view2, \.text),
            KPOneWayBinding(\.name, view3, \.text)
        ])
        binding.model = .random
        
        // Assert
        XCTAssertEqual(view1.text, binding.model.name)
        XCTAssertEqual(view2.text, binding.model.name)
        XCTAssertEqual(view3.text, binding.model.name)
        
        // Action
        let text = String.random
        binding.update(\.name, with: text)
        
        // Assert
        XCTAssertEqual(binding.model.name, text)
        XCTAssertEqual(view1.text, text)
        XCTAssertEqual(view2.text, text)
        XCTAssertEqual(view3.text, text)
        
        // Action
        binding.update(\.name, with: nil)
        
        // Assert
        XCTAssertNil(binding.model.name)
        XCTAssertNil(view1.text)
        XCTAssertNil(view2.text)
        XCTAssertEqual(view3.text, UITextField().text)
    }
    
    func testManyFieldToOneView() throws {
        // Arrange
        let lbl = UILabel()
        
        // Action
        binding.bind( [
            KPOneWayBinding(\.name, lbl, \.text),
            KPOneWayBinding(\.email, lbl, \.text),
            KPOneWayBinding(\.groupName, lbl, \.text)
        ])
        binding.model = .random
        
        // Assert
        XCTAssertEqual(lbl.text, binding.model.groupName)
        
        // Action & Assert
        binding.update(\.name, with: String.random)
        XCTAssertEqual(lbl.text, binding.model.name)
        
        // Action & Assert
        binding.update(\.email, with: String.random)
        XCTAssertEqual(lbl.text, binding.model.email)
        
        // Action & Assert
        binding.update(\.groupName, with: String.random)
        XCTAssertEqual(lbl.text, binding.model.groupName)
    }
    
    func testOneFormat() throws {
        // Arrange
        let text = String.random
        let lbl = UILabel()
        
        // Action
        
        binding.bind(
            KPOneWayBinding(\.name, lbl, { $0.text = ($1 ?? "") + text })
        )
        binding.model = .random
        
        // Assert
        XCTAssertEqual(lbl.text, (binding.model.name ?? "") + text)
        
        // Action
        let text1 = String.random
        
        // Action & Assert
        binding.update(\.name, with: text1)
        XCTAssertEqual(binding.model.name, text1)
        XCTAssertEqual(lbl.text, (binding.model.name ?? "") + text)
        
        // Action & Assert
        binding.update(\.name, with: nil)
        XCTAssertNil(binding.model.name)
        XCTAssertEqual(lbl.text, text)
    }
    
    func testMultileFormat() throws {
        // Arrange
        let text1 = String.random
        let text2 = String.random
        
        let lbl = UILabel()
        let field = UITextField()
        
        // Action
        binding.bind([
            KPOneWayBinding(\.name, lbl, { $0.text = ($1 ?? "") + text1 }),
            KPOneWayBinding(\User.name, field, { $0.text = ($1 ?? "") + text2 })
        ])
        binding.model = .random
        
        // Assert
        XCTAssertEqual(lbl.text, (binding.model.name ?? "") + text1)
        XCTAssertEqual(field.text, (binding.model.name ?? "") + text2)
        
        // Action & Assert
        let text = String.random
        binding.update(\.name, with: text)
        XCTAssertEqual(binding.model.name, text)
        XCTAssertEqual(lbl.text, (binding.model.name ?? "") + text1)
        XCTAssertEqual(field.text, (binding.model.name ?? "") + text2)
        
        // Action & Assert
        binding.update(\.name, with: nil)
        XCTAssertNil(binding.model.name)
        XCTAssertEqual(lbl.text, text1)
        XCTAssertEqual(field.text, text2)
    }
    
    func testOtherFormat() throws {
        // Arrange
        let lbl = UILabel()
        
        // Action
        binding.bind([
            KPOneWayBinding(\.name, lbl, { $0.layer.cornerRadius = CGFloat(Float($1 ?? "0") ?? 0) })
        ])
        
        // Assert
        XCTAssertEqual(lbl.layer.cornerRadius, 0)
        
        // Action & Assert
        let random = CGFloat.random(in: 0...1000)
        binding.update(\.name, with: "\(random)")
        XCTAssertEqual(binding.model.name, "\(random)")
        XCTAssertEqual(lbl.layer.cornerRadius, CGFloat(Float("\(random)") ?? 0))
        
        // Action & Assert
        binding.update(\.name, with: nil)
        XCTAssertNil(binding.model.name)
        XCTAssertEqual(lbl.layer.cornerRadius, 0)
    }
}
