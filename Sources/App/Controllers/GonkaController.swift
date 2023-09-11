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
        protected.put(":id", use: updateRace)
    }
    
    // MARK: CRUD
    
    func createRacing(_ req: Request) async throws -> GonkaModel {
        
        guard let gonkaData = try? req.content.decode(GonkaDTO.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Ошибка декодирования DTO"))
        }
        
        let gonkaID = UUID()
        
        let gonka = GonkaModel(id: gonkaID, name: gonkaData.name, city: gonkaData.city, description: gonkaData.description, date: gonkaData.date, geo: gonkaData.geo, image: "")
        
        let imagePath = req.application.directory.workingDirectory + "/Storage/Races" + "/\(gonka.id!).jpg"
        
        try await req.fileio.writeFile(.init(data: gonkaData.image), at: imagePath)
        gonka.image = imagePath
        try await gonka.save(on: req.db)
        return gonka
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
        guard let race = try await GonkaModel.find(req.parameters.get("id"), on: req.db) else {
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

struct GonkaDTO: Content {
    
    var name: String
    var city: String
    var description: String
    var date: String
    var geo: String
    var image: Data
}
