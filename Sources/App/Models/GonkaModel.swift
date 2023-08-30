//
//  File.swift
//  
//
//  Created by Артём Тюрморезов on 30.08.2023.
//

import Fluent
import Vapor

final class GonkaModel: Model, Content {

    static var schema: String = "allRacings"
    
    @ID var id: UUID?
    
    @Field(key: "name") var name: String
    @Field(key: "address") var address: String
    @Field(key: "description") var description: String
    @Field(key: "date") var date: String
    @Field(key: "geo") var geo: String
    @Field(key: "image") var image: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, address: String, description: String, date: String, geo: String, image: String) {
        self.id = id
        self.name = name
        self.address = address
        self.description = description
        self.date = date
        self.geo = geo
        self.image = image
    }
}
