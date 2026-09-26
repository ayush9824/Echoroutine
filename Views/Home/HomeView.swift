import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<TaskItem> { $0.isCompleted == false }) private var incompleteTasks: [TaskItem]
    
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                VStack(spacing: 8) {
                    Text("EchoRoutine")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Good to see you!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    if incompleteTasks.isEmpty {
                        Text("No tasks yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("\(incompleteTasks.count) tasks remaining")
                            .font(.headline)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                
                VStack(spacing: 16) {
                    NavigationLink(destination: TaskListView()) {
                        Text("View Tasks")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        showingAddTask = true
                    } label: {
                        Text("Add Task")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
                    .modelContext(modelContext)
            }
        }
    }
}

#Preview {
    HomeView()
}
