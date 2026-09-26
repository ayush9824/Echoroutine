import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("EchoRoutine")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your routines and tasks will appear here.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
