import SwiftUI
import EventKit

struct ReminderHeatmapView: View {
    @StateObject private var viewModel = ReminderHeatmapViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HeatmapGridView(data: viewModel.completionData,
                       selectedDate: $viewModel.selectedDate)
                .frame(height: 200)
            
            if let selectedDate = viewModel.selectedDate {
                let count = viewModel.completionData[selectedDate] ?? 0
                VStack(spacing: 8) {
                    Text(viewModel.formatDate(selectedDate))
                        .font(.subheadline)
                    Text("완료된 미리알림: \(count)개")
                        .font(.headline)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            viewModel.requestAccess()
        }
    }
}
