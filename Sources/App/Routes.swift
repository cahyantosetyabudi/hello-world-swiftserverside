import Vapor

class User: JSONRepresentable, ResponseRepresentable, JSONInitializable {
    var firstName: String!
    var lastName: String!
    
    convenience required init(json: JSON) throws {
        try self.init(firstName: json.get("firstName"), lastName: json.get("lastName"))
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("firstName", firstName)
        try json.set("lastName", lastName)
        
        return json
    }
    
}

extension Droplet {
    func setupRoutes() throws {
        
        //Get /users
        get("users") { req in
            var users = [User]()
            users.append(User(firstName: "Cahyanto", lastName: "Setya Budi"))
            users.append(User(firstName: "John", lastName: "Doe"))
            users.append(User(firstName: "Marry", lastName: "Doe"))

            //With JSONRepresentable
            return try users.makeJSON()
        }
        
        //Get /user
        get("user") { req in
            var json = JSON()
            try json.set("firstName", "John")
            try json.set("lastName", "Doe")

            let user = try User(json: json)
//            let user = User(firstName: "Cahyanto", lastName: "Setya Budi")
            
            //With JSONRepresentable
//            return try user.makeJSON()
            
            //With ResponseRepresentable
            return user
        }
        
        //Get /user/id
        get("user",":id") { req in
            guard let userId = req.parameters["id"]?.int else {
                fatalError("id not found")
            }
            
            return "user id is \(userId)"
        }
        
        //Get /movies/genre/year
        get("movies/:genre/:year") { req in
            guard let genre = req.parameters["genre"]?.string, let year = req.parameters["year"]?.int else {
                fatalError("Invalid parameters")
            }
            
            return "Genre is \(genre) and year is \(year)"
        }
        
        //Get /customer/id
        get("customer", Int.parameter) { req in
            let customerId = try req.parameters.next(Int.self)
            
            return "Customer id is \(customerId)"
        }
        
        //Grouping
        group("v1") { v1 in
            v1.get("customers") { req in
                return "customers in v1"
            }
            
            v1.get("users") { req in
                return "users in v1"
            }
        }
        
        //Grouped
        let v2 = grouped("v2")
        v2.get("customers") { req in
            return "customers in v2"
        }
        
        v2.get("users") { req in
            return "users in v2"
        }
        
        //Post
        post("customer") { req in
            guard let name = req.json?["name"]?.string, let age = req.json?["age"]?.int else {
                fatalError("Invalid parameters")
            }
            return "the name is \(name) and the age is \(age)"
        }
    
    }
}
