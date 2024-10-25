import SwiftData
import Foundation

@Model
class Report {
    @Attribute(.unique) var id: UUID
    var des: String
    var category: String
    var importance: Int
    var dateCreated: Date
    var destination: Destination? // Reference to Destination

    init(des: String, category: String, importance: Int, destination: Destination? = nil) {
        self.id = UUID()
        self.des = des
        self.category = category
        self.importance = importance
        self.dateCreated = Date()
        self.destination = destination
    }
}
