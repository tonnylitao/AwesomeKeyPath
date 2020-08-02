//
//  KPInfixOperatorTests.swift
//  AwesomeKeyPath_Tests
//
//  Created by Tonny on 20/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import XCTest
import AwesomeKeyPath

fileprivate struct Model {
    var string = "text"
    var ostring1: String?
    var ostring2: String?
    
    var bool = true
    var obool: Bool?
    
    var int1 = 1
    var oint: Int?
    
    var int2 = 1
    
    var double1 = 1.0
    var odouble: Double?
    
    var float: Float = 1.0
    var ofloat: Float?
}

class KPInfixOperatorTests: XCTestCase {
    private var user: Model!
    
    let int1 = Int.random(in: -9000...9000)
    let int2 = Int.random(in: -9000...9000)
    let int3 = Int.random(in: -9000...9000)
    let int4 = Int.random(in: -9000...9000)
    
    let double1 = Double.random(in: -9000.0...9000.0)
    let double2 = Double.random(in: -9000.0...9000.0)
    let double3 = Double.random(in: -9000.0...9000.0)
    let double4 = Double.random(in: -9000.0...9000.0)
    
    let float1 = Float.random(in: -9000.0...9000.0)
    let float2 = Float.random(in: -9000.0...9000.0)
    let float3 = Float.random(in: -9000.0...9000.0)
    let float4 = Float.random(in: -9000.0...9000.0)
    
    let string1 = String.random
    let string2 = String.random
    
    private let intKP1 = \Model.int1
    private let intKP2 = \Model.int2
    
    private let ostringKP1 = \Model.ostring1
    private let ostringKP2 = \Model.ostring2
    
    override func setUpWithError() throws {
        user = Model()
        user.int1 = int1
        user.int2 = int2
    }
    
    private let arr = [Client(
        gender: "male",
        name: Name(title: "", first: "Louane", last: "Vidal"),
        location: Location(
            street: Street(number: 2479, name: "Place du 8 Février 1962"),
            city: "Avignon",
            state: "Vendée",
            country: "France",
            postcode: 78276,
            coordinates: Coordinates( latitude: 2.0565, longitude: 95.2422 )
        ),
        email: "louane.vidal@example.com",
        dob: Dob( date: "1966-06-26T11:50:25.558Z", age: 54 ),
        phone: "02-62-35-18-98",
        cell: "06-07-80-83-11",
        picture: Picture(
            large: "https://randomuser.me/api/portraits/women/88.jpg",
            medium: "https://randomuser.me/api/portraits/med/women/88.jpg",
            thumbnail: "https://randomuser.me/api/portraits/thumb/women/88.jpg"
        ),
        nat: "FR",
        isAdmin: true
    )]
    
    override func tearDownWithError() throws {}

    func testAddition() throws {
        XCTAssertEqual((intKP1 + int2)(user), int1 + int2)
        XCTAssertEqual((int2 + intKP1)(user), int2 + int1)
        
        XCTAssertEqual(((intKP1 + int2) + int3)(user), int1 + int2 + int3)
        XCTAssertEqual((int3 + (intKP1 + int2))(user), int1 + int2 + int3)
        
        XCTAssertEqual(((intKP1 + int3) + intKP2)(user), int1 + int2 + int3)
        XCTAssertEqual((intKP2 + (intKP1 + int3))(user), int1 + int2 + int3)
        
        XCTAssertEqual((intKP1 + intKP2)(user), int1 + int2)
        
        //
        XCTAssertEqual((intKP1 - int2)(user), int1 - int2)
        XCTAssertEqual((int2 - intKP1)(user), int2 - int1)
        
        XCTAssertEqual((intKP1 - intKP2)(user), int1 - int2)
        
        XCTAssertEqual(((intKP1 - int2) - int3)(user), int1 - int2 - int3)
        XCTAssertEqual((int3 - (intKP1 - int2))(user), int3 - (int1 - int2))
        
        XCTAssertEqual(((intKP1 - int3) - intKP2)(user), int1 - int3 - int2)
        XCTAssertEqual((intKP2 - (intKP1 - int3))(user), int2 - (int1 - int3))
    }
    
    func testMultiply() throws {
        XCTAssertEqual((intKP1 * int2)(user), int1 * int2)
        XCTAssertEqual((int2 * intKP1)(user), int2 * int1)
        
        XCTAssertEqual(((intKP1 * int2) * int3)(user), int1 * int2 * int3)
        XCTAssertEqual((int3 * (intKP1 * int2))(user), int1 * int2 * int3)
        
        XCTAssertEqual((intKP1 * intKP2)(user), int1 * int2)
        
        XCTAssertEqual(((intKP1 * intKP2) * int3)(user), int1 * int2 * int3)
        XCTAssertEqual((int3 * (intKP1 * intKP2))(user), int1 * int2 * int3)
    }
    
    func testDivide() throws {
        
        let kp = \Model.int1
        
        XCTAssertEqual((kp / int2)(user), int1 / int2)
        XCTAssertEqual((kp / int2 / int3)(user), int1 / int2 / int3)
        
        user.int1 = int4
        XCTAssertEqual((int1 / intKP1)(user), int1 / int4)
    }
    
    func testRemainder() throws {
        
        let kp = \Model.int1
        
        XCTAssertEqual((kp % int2)(user), int1 % int2)
        XCTAssertEqual((kp % int2 % int3)(user), int1 % int2 % int3)
        
        user.int1 = int1
        user.int2 = int2
        XCTAssertEqual((intKP1 % intKP2)(user), int1 % int2)
    }
    
    func testMath() {
        
        let kp = \Model.int1
        
        XCTAssertEqual((kp + int2 * int3)(user), int1 + int2 * int3)
        XCTAssertEqual((kp * int2 + int3)(user), int1 * int2 + int3)
        
        XCTAssertEqual((kp + int2 - int3)(user), int1 + int2 - int3)
        XCTAssertEqual((kp - int2 + int3)(user), int1 - int2 + int3)
        
        XCTAssertEqual((kp + int2 / int3)(user), int1 + int2 / int3)
        XCTAssertEqual((kp / int2 + int3)(user), int1 / int2 + int3)
        
        XCTAssertEqual((kp + int2 % int3)(user), int1 + int2 % int3)
        XCTAssertEqual((kp % int2 + int3)(user), int1 % int2 + int3)
        
        XCTAssertEqual((kp - int2 / int3)(user), int1 - int2 / int3)
        XCTAssertEqual((kp / int2 - int3)(user), int1 / int2 - int3)
        
        XCTAssertEqual((kp - int2 % int3)(user), int1 - int2 % int3)
        XCTAssertEqual((kp % int2 - int3)(user), int1 % int2 - int3)
        
        XCTAssertEqual((kp - int2 * int3)(user), int1 - int2 * int3)
        XCTAssertEqual((kp * int2 - int3)(user), int1 * int2 - int3)
        
        XCTAssertEqual((kp / int2 * int3)(user), int1 / int2 * int3)
        XCTAssertEqual((kp * int2 / int3)(user), int1 * int2 / int3)
        
        XCTAssertEqual((kp / int2 % int3)(user), int1 / int2 % int3)
        XCTAssertEqual((kp % int2 / int3)(user), int1 % int2 / int3)
        
        XCTAssertEqual((kp * int2 % int3)(user), int1 * int2 % int3)
        XCTAssertEqual((kp % int2 * int3)(user), int1 % int2 * int3)
    }
    
    func testAddAssign() throws {
        
        (\Model.int1 += int2)(&user)
        XCTAssertEqual(user.int1, int1 + int2)
    }
    
    func testSubtractAssign() throws {
        
        (\Model.int1 -= int2)(&user)
        XCTAssertEqual(user.int1, int1 - int2)
    }
    
    func testMultiplyAssign() throws {
        
        (\Model.int1 *= int2)(&user)
        XCTAssertEqual(user.int1, int1 * int2)
    }
    
    func testDivideBinaryIntegerAssign() throws {
        
        (\Model.int1 /= int2)(&user)
        XCTAssertEqual(user.int1, int1 / int2)
    }
    
    func testDivideFloatingPointAssign() throws {
        user.double1 = double1
        
        (\Model.double1 /= double2)(&user)
        XCTAssertEqual(user.double1, double1 / double2)
        
        //
        user.float = float1
        
        (\Model.float /= float2)(&user)
        XCTAssertEqual(user.float, float1 / float2)
    }
    
    func testOptional() throws {
        XCTAssertEqual((ostringKP1 ?? self.string1)(user), string1)
        XCTAssertNil(ostringKP1.getValue(user))
        XCTAssertNil((ostringKP1 ?? ostringKP2)(user))
        XCTAssertEqual((ostringKP1 ?? ostringKP2 ?? self.string1)(user), string1)
        
        user.ostring1 = string1
        XCTAssertEqual((ostringKP1 ?? String.random)(user), string1)
        
        let string: String? = nil
        user.ostring1 = nil
        XCTAssertEqual((ostringKP1 ?? string ?? self.string2)(user), string2)
        
        user.ostring2 = String.random
        XCTAssertEqual(((ostringKP1 ?? string) ?? ostringKP2)(user), user.ostring2)
    }
    
    func testComplex() throws {
        typealias Rule = (Client) -> Bool
        
        let rule1: Rule = \.gender == "male"
        let rule2: Rule = \.name.title.isEmpty
        let rule3: Rule = \.name.first.count > 3
        let rule4: Rule = \.name.last.count < 10
        let rule5: Rule = \.location.postcode >= 70000
        let rule6: Rule = \.location.postcode != 75000
        let rule7: Rule = \.location.postcode <= 80000
        let rule8: Rule = \.location.coordinates.latitude == 2.0565
        let rule9: Rule = \.email.isEmail
        let rule10: Rule = { $0.email.hasSuffix("@example.com") }
        let rule11: Rule = \.picture.large.isEmpty.not
        let rule12: Rule = \.isAdmin
        
        let result = arr.filter(
            (rule1 && rule2 && rule3 && rule4 && rule5 && rule6) ||
            (rule7 && rule8 && rule9 && rule10 && rule11 && rule12)
        ).sorted(by: \.name.first)
        
        XCTAssertNotNil(result.first)
    }
}

// MARK: - Result
fileprivate struct Client: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let dob: Dob
    let phone, cell: String
    let picture: Picture
    let nat: String
    let isAdmin: Bool
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}


// MARK: - Location
struct Location: Codable {
    let street: Street
    let city, state, country: String
    let postcode: Int
    let coordinates: Coordinates
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - Street
struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
