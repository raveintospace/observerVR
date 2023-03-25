//
//  UserModel.swift
//  ObserverVR
//
//  Created by Uri on 25/3/23.
//

import Foundation

struct UserModel {
    let name: String
    let lastName: String
    
    static func getUsers() -> [UserModel]{
        return (1..<51).map({UserModel(name: "Uri", lastName: "Darko \($0)")})
    }
}
