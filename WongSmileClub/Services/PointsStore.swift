import Foundation
import SwiftData

@MainActor
struct PointsStore {
    let context: ModelContext

    func addTransaction(_ transaction: PointsTransaction) {
        context.insert(transaction)
        try? context.save()
    }
}
