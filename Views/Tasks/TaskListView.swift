import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \TaskItem.title, order: .forward) private var tasks: [TaskItem]
    
    var sortedTasks: [TaskItem] {
        tasks.sorted { lhs, rhs in
            if lhs.isCompleted == rhs.isCompleted {
                return lhs.title < rhs.title
            }
            return !lhs.isCompleted && rhs.isCompleted
        }
    }
    
    @State private var showingAddTask = false
    @State private var taskToEdit: TaskItem?
    
    var body: some View {
        List {
            if tasks.isEmpty {
                VStack(spacing: 12) {
                    Text("No tasks yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button("Add Task") {
                        showingAddTask = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 40)
            } else {
                ForEach(sortedTasks) { task in
                    TaskRowView(task: task, toggleAction: {
                        toggleCompletion(for: task)
                    })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            taskToEdit = task
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                toggleCompletion(for: task)
                            } label: {
                                Label(task.isCompleted ? "Uncomplete" : "Complete", 
                                      systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark")
                            }
                            .tint(task.isCompleted ? .orange : .green)
                        }
                }
                .onDelete(perform: deleteTasks)
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddTask = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add New Task")
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
                .modelContext(modelContext)
        }
        .sheet(item: $taskToEdit) { task in
            EditTaskView(task: task)
                .modelContext(modelContext)
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            let task = sortedTasks[index]
            modelContext.delete(task)
        }
        try? modelContext.save()
    }
    
    private func toggleCompletion(for task: TaskItem) {
        task.isCompleted.toggle()
        try? modelContext.save()
    }
}

struct TaskRowView: View {
    let task: TaskItem
    var toggleAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: toggleAction) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .secondary)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                HStack {
                    Text(task.category)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                        .foregroundColor(.blue)
                    
                    Text(task.priority.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(priorityColor(task.priority).opacity(0.1))
                        .cornerRadius(4)
                        .foregroundColor(priorityColor(task.priority))
                    
                    if let scheduledTime = task.scheduledTime {
                        Text(scheduledTime, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .opacity(task.isCompleted ? 0.6 : 1.0)
    }
    
    private func priorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

#Preview {
    NavigationStack {
        TaskListView()
    }
}
