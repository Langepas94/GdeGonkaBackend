//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 30.08.2023.
//

import Fluent
import Vapor

struct CreateGonka: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        let scheme = database.schema("allRacings")
            .id()
            .field("name", .string, .required)
            .field("city", .string, .required)
            .field("description", .string)
            .field("date", .string, .required)
            .field("geo", .string, .required)
            .field("image", .string)
        
          try await scheme.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        
        let scheme = database.schema("allRacings")
        try await scheme.delete()
    }
    
}
