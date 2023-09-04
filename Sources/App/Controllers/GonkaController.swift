//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 04.09.2023.
//

import Fluent
import Vapor

struct GonkaController: RouteCollection {
    
    // register all route's handlers
    func boot(routes: Vapor.RoutesBuilder) throws {
        let raceGroup = routes.grouped("allraces")
        raceGroup.post(use: createRacing)
        raceGroup.get(use: allRacings)
        raceGroup.get(":cityName", use: getRacesByCity)
    }
    
    func createRacing(_ req: Request) async throws -> GonkaModel {
        guard let race = try? req.content.decode(GonkaModel.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Ошибка декодирования"))
        }
        try await race.save(on: req.db)
        return race
    }
    
    func allRacings(_ req: Request) async throws -> [GonkaModel] {
        let allRacings = try await GonkaModel.query(on: req.db).all()
        return allRacings
    }
    
    func getRacesByCity(_ req: Request) async throws -> [GonkaModel] {
     
        let filteredRacings = try await GonkaModel.query(on: req.db)
            .filter(\.$city == req.parameters.get("cityName")!)
            .all()
        
        print(filteredRacings)
        return filteredRacings
        
        
    }
    
}
