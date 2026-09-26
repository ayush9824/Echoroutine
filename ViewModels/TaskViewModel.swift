import Foundation
import SwiftData

struct TaskValidator {
    static let categories = [
        "Work", "Study", "Personal", "Fitness", 
        "Health", "Shopping", "Finance", "Travel", 
        "Household", "General"
    ]
    
    static func isValidTitle(_ title: String) -> Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
}
