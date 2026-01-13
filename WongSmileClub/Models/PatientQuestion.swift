import Foundation
import SwiftData

@Model
final class PatientQuestion {
    var id: UUID
    var createdAt: Date
    var text: String
    var isAnswered: Bool

    init(id: UUID = UUID(), createdAt: Date = Date(), text: String = "", isAnswered: Bool = false) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
        self.isAnswered = isAnswered
    }
}
