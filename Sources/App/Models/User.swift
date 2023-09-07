//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 07.09.2023.
//

import Vapor
import Fluent

final class User: Model, Content {
    @ID var id: UUID?
    
    static var schema: String = "users"
    
    @Field(key: "name") var name: String
    @Field(key: "login") var login: String
    @Field(key: "password") var password: String
    @Field(key: "role") var role: String
    @Field(key: "profilePic") var profilePic: String?
    
    final class Public: Content {
        var id: UUID?
        var name: String
        var login: String
        var role: String
        var profilePic: String?
        
        init(id: UUID? = nil, name: String, login: String, role: String, profilePic: String? = nil) {
            self.id = id
            self.name = name
            self.login = login
            self.role = role
            self.profilePic = profilePic
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        let pub = User.Public(id: self.id, name: self.name, login: self.login, role: self.role, profilePic: self.profilePic)
        return pub
    }
}

enum UserRole: String {
    case admin = "admin"
    case basicUser = "basicUser"
}
