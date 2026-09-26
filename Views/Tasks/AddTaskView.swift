import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var hasScheduledTime: Bool = false
    @State private var scheduledTime: Date = Date()
    @State private var category: String = "General"
    @State private var priority: TaskPriority = .medium
    
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .accessibilityLabel("Task Title")
                    
                    Picker("Category", selection: $category) {
                        ForEach(TaskValidator.categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    .accessibilityLabel("Task Category")
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { p in
                            Text(p.rawValue.capitalized).tag(p)
                        }
                    }
                    .accessibilityLabel("Task Priority")
                }
                
                Section(header: Text("Scheduling")) {
                    Toggle("Schedule Time", isOn: $hasScheduledTime)
                        .accessibilityLabel("Enable Schedule Time")
                    
                    if hasScheduledTime {
                        DatePicker("Time", selection: $scheduledTime)
                            .accessibilityLabel("Scheduled Time")
                    }
                }
                
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                    }
                }
            }
        }
    }
    
    private func saveTask() {
        guard TaskValidator.isValidTitle(title) else {
            errorMessage = "Title cannot be empty."
            return
        }
        
        let newTask = TaskItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            scheduledTime: hasScheduledTime ? scheduledTime : nil,
            category: category,
            priority: priority
        )
        
        modelContext.insert(newTask)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save task: \(error.localizedDescription)"
        }
    }
}

#Preview {
    AddTaskView()
}
