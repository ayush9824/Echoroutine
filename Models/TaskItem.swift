import Foundation
import SwiftData

enum TaskPriority: String, Codable, CaseIterable {
    case low
    case medium
    case high
}

@Model
final class TaskItem {
    @Attribute(.unique)
    var id: UUID
    var title: String
    var scheduledTime: Date?
    var category: String
    var priority: TaskPriority
    var isCompleted: Bool
    var missedAlertTriggered: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        scheduledTime: Date? = nil,
        category: String = "General",
        priority: TaskPriority = .medium,
        isCompleted: Bool = false,
        missedAlertTriggered: Bool = false
    ) {
        self.id = id
        self.title = title
        self.scheduledTime = scheduledTime
        self.category = category
        self.priority = priority
        self.isCompleted = isCompleted
        self.missedAlertTriggered = missedAlertTriggered
    }
}
