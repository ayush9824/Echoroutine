import Foundation
import SwiftData

@Model
final class DailyRoutine {
    @Attribute(.unique)
    var id: UUID
    var title: String
    var targetTime: Date
    var daysOfWeek: [Int]
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        targetTime: Date,
        daysOfWeek: [Int] = [2, 3, 4, 5, 6], // Default: Mon - Fri
        isActive: Bool = true
    ) {
        self.id = id
        self.title = title
        self.targetTime = targetTime
        self.daysOfWeek = daysOfWeek
        self.isActive = isActive
    }
}
