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
        raceGroup.get(use: allRacings)
        raceGroup.get(":cityName", use: getRacesByCity)
        
        // защита через аутентификатор и мидлвор
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = raceGroup.grouped(basicMW, guardMW)
        protected.post(use: createRacing)
        protected.delete(":cityName", use: deleteRace)
        protected.put(":cityName", use: updateRace)
    }
    
    // MARK: CRUD
    
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
    
    func deleteRace(_ req: Request) async throws -> HTTPStatus {
        guard let race = try await GonkaModel.find(req.parameters.get("cityName"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await race.delete(on: req.db)
        return .ok
    }
    
    func updateRace(_ req: Request) async throws -> GonkaModel {
        guard let race = try await GonkaModel.find(req.parameters.get("cityName"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedRace = try req.content.decode(GonkaModel.self)
        
        race.name = updatedRace.name
        race.city = updatedRace.city
        race.description = updatedRace.description
        race.date = updatedRace.date
        race.geo = updatedRace.geo
        race.image = updatedRace.image
        
        try await race.save(on: req.db)
        return race
    }
}
