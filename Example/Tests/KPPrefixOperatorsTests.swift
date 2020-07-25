//
//  KPOperatorsTests.swift
//  AwesomeKeyPath_Tests
//
//  Created by Tonny on 20/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

import XCTest
import AwesomeKeyPath

fileprivate struct Model {
    var string = "text"
    var oString: String?
    
    var bool = true
    var obool: Bool?
    
    var int = 1
    var oint: Int?
    
    var int1 = 1
    
    var double = 1.0
    var odouble: Double?
    
    var float: Float = 1.0
    var ofloat: Float?
}

class KPPrefixOperatorTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testLogicalNot() throws {
        var user = Model()
        var value = true
        user.bool = value
        
        let kp = \Model.bool
        
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertEqual((!kp)(user), !value)
        XCTAssertEqual((!(!kp))(user), !(!value))
        XCTAssertEqual((!(!(!kp)))(user), !(!(!value)))
        
        
        value = false
        user.bool = value
        
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertEqual((!kp)(user), !value)
        XCTAssertEqual((!(!kp))(user), !(!value))
        XCTAssertEqual((!(!(!kp)))(user), !(!(!value)))
    }
    
    func testBitWiseNot() throws {
        var user = Model()
        let value = Int.random(in: Int.min...Int.max)
        user.int = value
        
        let kp = \Model.int
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertEqual((~kp)(user), ~value)
        XCTAssertEqual((~(~kp))(user), ~(~value))
        XCTAssertEqual((~(~(~kp)))(user), ~(~(~value)))
    }
    
    func testUnaryPlus() throws {
        var user = Model()
        let value = Int.random(in: Int.min...Int.max)
        user.int = value
        
        let kp = \Model.int
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertEqual((+kp)(user), +value)
        XCTAssertEqual((+(+kp))(user), +(+value))
        XCTAssertEqual((+(+(+kp)))(user), +(+(+value)))
    }
    
    func testUnaryMinus() throws {
        var user = Model()
        let value = Int.random(in: Int.min...Int.max)
        user.int = value
        
        let kp = \Model.int
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertEqual((-kp)(user), -value)
        XCTAssertEqual((-(-kp))(user), -(-value))
        XCTAssertEqual((-(-(-kp)))(user), -(-(-value)))
    }
    
    func testHalfOpenRange() throws {
        var user = Model()
        let value = Int.random(in: Int.min...Int.max)
        user.int = value
        
        let kp = \Model.int
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertTrue((..<kp)(user).contains(value-1))
        XCTAssertEqual((..<kp)(user).upperBound, (..<value).upperBound)
    }
    
    func testClosedRange() throws {
        var user = Model()
        let value = Int.random(in: Int.min...Int.max)
        user.int = value
        
        let kp = \Model.int
        XCTAssertEqual(kp.getValue(user), value)
        XCTAssertTrue((...kp)(user).contains(value-1))
        XCTAssertEqual((...kp)(user).upperBound, (...value).upperBound)
    }
}
