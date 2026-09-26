import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var task: TaskItem
    
    @State private var draftTitle: String = ""
    @State private var draftHasScheduledTime: Bool = false
    @State private var draftScheduledTime: Date = Date()
    @State private var draftCategory: String = "General"
    @State private var draftPriority: TaskPriority = .medium
    
    @State private var errorMessage: String?
    
    init(task: TaskItem) {
        self.task = task
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $draftTitle)
                        .accessibilityLabel("Task Title")
                    
                    Picker("Category", selection: $draftCategory) {
                        ForEach(TaskValidator.categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    .accessibilityLabel("Task Category")
                    
                    Picker("Priority", selection: $draftPriority) {
                        ForEach(TaskPriority.allCases, id: \.self) { p in
                            Text(p.rawValue.capitalized).tag(p)
                        }
                    }
                    .accessibilityLabel("Task Priority")
                }
                
                Section(header: Text("Scheduling")) {
                    Toggle("Schedule Time", isOn: $draftHasScheduledTime)
                        .accessibilityLabel("Enable Schedule Time")
                    
                    if draftHasScheduledTime {
                        DatePicker("Time", selection: $draftScheduledTime)
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
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadDraft()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
        }
    }
    
    private func loadDraft() {
        draftTitle = task.title
        draftCategory = task.category
        draftPriority = task.priority
        if let st = task.scheduledTime {
            draftHasScheduledTime = true
            draftScheduledTime = st
        } else {
            draftHasScheduledTime = false
        }
    }
    
    private func saveChanges() {
        guard TaskValidator.isValidTitle(draftTitle) else {
            errorMessage = "Title cannot be empty."
            return
        }
        
        task.title = draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        task.category = draftCategory
        task.priority = draftPriority
        task.scheduledTime = draftHasScheduledTime ? draftScheduledTime : nil
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to update task: \(error.localizedDescription)"
        }
    }
}
