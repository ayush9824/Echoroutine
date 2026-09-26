import XCTest
import SwiftData
@testable import EchoRoutine

final class EchoRoutineTests: XCTestCase {

    @MainActor
    func testTaskItemInitialization() throws {
        let task = TaskItem(
            title: "Test Task",
            priority: .high
        )
        
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.priority, .high)
        XCTAssertFalse(task.isCompleted)
    }

    @MainActor
    func testDailyRoutineInitialization() throws {
        let date = Date()
        let routine = DailyRoutine(
            title: "Morning Workout",
            targetTime: date,
            daysOfWeek: [2, 4, 6]
        )
        
        XCTAssertEqual(routine.title, "Morning Workout")
        XCTAssertEqual(routine.targetTime, date)
        XCTAssertEqual(routine.daysOfWeek, [2, 4, 6])
        XCTAssertTrue(routine.isActive)
    }

    func testTaskPriority() {
        XCTAssertEqual(TaskPriority.low.rawValue, "low")
        XCTAssertEqual(TaskPriority.medium.rawValue, "medium")
        XCTAssertEqual(TaskPriority.high.rawValue, "high")
        
        let allCases = TaskPriority.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.low))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.high))
    }

    @MainActor
    func testModelContainerCreation() throws {
        let schema = Schema([
            TaskItem.self,
            DailyRoutine.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        XCTAssertNotNil(container)
    }
    
    // MARK: - Phase 2 Tests
    
    func testTaskValidatorEmptyTitle() {
        XCTAssertFalse(TaskValidator.isValidTitle(""), "Empty string should be invalid")
        XCTAssertFalse(TaskValidator.isValidTitle("   "), "Whitespace string should be invalid")
        XCTAssertFalse(TaskValidator.isValidTitle("\n"), "Newline string should be invalid")
        XCTAssertTrue(TaskValidator.isValidTitle("Valid Task"), "Valid title should be valid")
    }
    
    @MainActor
    func testTaskCompletionToggle() {
        let task = TaskItem(title: "Toggle Test")
        XCTAssertFalse(task.isCompleted)
        
        task.isCompleted = true
        XCTAssertTrue(task.isCompleted)
        
        task.isCompleted = false
        XCTAssertFalse(task.isCompleted)
    }
    
    @MainActor
    func testTaskPersistenceAndDelete() throws {
        let schema = Schema([TaskItem.self, DailyRoutine.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        let context = container.mainContext
        
        let task = TaskItem(title: "Persistent Task")
        context.insert(task)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<TaskItem>()
        var fetchedTasks = try context.fetch(fetchDescriptor)
        XCTAssertEqual(fetchedTasks.count, 1)
        
        context.delete(task)
        try context.save()
        
        fetchedTasks = try context.fetch(fetchDescriptor)
        XCTAssertEqual(fetchedTasks.count, 0)
    }
}
