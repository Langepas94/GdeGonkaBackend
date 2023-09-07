//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 07.09.2023.
//

import Foundation
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createUser)
        usersGroup.get(use: getAllUsers)
        usersGroup.get(":id", use: getOnceUser)
    }
    
    func createUser(_ req: Request) async throws -> User.Public {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    func getAllUsers(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        let publics = users.map { user in
            user.convertToPublic()
        }
        return publics
    }
    
    func getOnceUser(_ req: Request) async throws -> User.Public {
        guard let user  = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.convertToPublic()
    }
    
}
