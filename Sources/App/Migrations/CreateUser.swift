//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 07.09.2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users").delete()
    }
    
    func prepare(on database: FluentKit.Database) async throws {
        let scheme = database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("login", .string, .required)
            .field("password", .string)
            .field("role", .string, .required)
            .field("profilePic", .string)
        
          try await scheme.create()
    }
    
}
