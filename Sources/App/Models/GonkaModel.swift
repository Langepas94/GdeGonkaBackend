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
    @Field(key: "date") var title: Date
    @Field(key: "geo") var geo: String
    @Field(key: "image") var image: String
    
}
