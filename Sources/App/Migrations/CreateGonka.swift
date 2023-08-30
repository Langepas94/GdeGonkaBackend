//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 30.08.2023.
//

import Fluent
import Vapor

struct CreateGonka: Migration {
    
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("allRacings")
            .id()
            .field("name", .string, .required)
            .field("address", .string, .required)
            .field("description", .string)
            .field("date", .string, .required)
            .field("geo", .string, .required)
            .field("image", .string)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("allRacings").delete()
    }
    
}
