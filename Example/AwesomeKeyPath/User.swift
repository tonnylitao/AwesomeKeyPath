//
//  User.swift
// AwesomeKeyPath
//
//  Created by Tonny on 8/07/20.
//  Copyright © 2020 Tonny. All rights reserved.
//  Github: https://github.com/tonnylitao/AwesomeKeyPath
//

import Foundation

struct User {
    var groupName: String?
    var name, email: String?
    
    var age: Int = 10
    var activity: Float = 0.4
    
    var likeKiwi = false
    
    var travel = false
    var hiking = false
    
    var info: String?
    
    var address = Address()
}

extension User: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "[groupName:\(groupName ?? "") name:\(name ?? "") email:\(email ?? "") age:\(age) activity:\(activity) likeKiwi:\(likeKiwi) travel:\(travel) hiking:\(hiking) info:\(info ?? "") address:\(address.address1 ?? "")]"
    }
}

struct Address {
    var address1: String?
}

extension User {
    static var random: User {

        return User(
            groupName: "Group \(Int.random(in: 1...100))",
            name: String.random,
            email: "\(Int(Date().timeIntervalSince1970))@gmail.com",
            age: Int.random(in: 18...90),
            activity: Float.random(in: 0...1),
            likeKiwi: Bool.random(),
            travel: Bool.random(),
            hiking: Bool.random()
        )
    }
}

extension String {
    
    static var random: String {
        let alpha = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
        
        return (3...Int.random(in: 4...10)).compactMap({ _ in String(alpha.randomElement() ?? "A") }).joined(separator: "")
    }
}
