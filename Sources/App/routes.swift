import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    try app.register(collection: GonkaController())
    try app.register(collection: UsersController())
}
