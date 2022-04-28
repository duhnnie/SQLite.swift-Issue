import SQLite
import Foundation

struct Person: Codable {
    let id: Int?
    let name: String
    let email: String?
    
    init(id: Int? = nil, name: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
    }
}

let db = try Connection(NSHomeDirectory() + "/dbtest.sqlite")

let person = Table("person")
let id = Expression<Int64>("id")
let name = Expression<String>("name")
let email = Expression<String?>("email")

let createTable = person.create(ifNotExists: true) { t in
    t.column(id, primaryKey: true)
    t.column(name)
    t.column(email)
}

try db.run(createTable)

let person1 = Person(name: "John", email: "john@doe.com")
let person2 = Person(name: "David", email: nil)
let personsArray = [person1, person2]

do {
    let insert = try person.insertMany(personsArray)
    try db.run(insert)
} catch {
    print("Error \(error.localizedDescription)")
}
