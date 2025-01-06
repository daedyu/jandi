import SwiftUI
import EventKit

struct ReminderHeatmapView: View {
    @StateObject private var viewModel = ReminderHeatmapViewModel()
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HeatmapGridView(data: viewModel.completionData,
                               selectedDate: $viewModel.selectedDate)
                        .frame(height: 200)
                        .id("heatmap")
                }
                .onAppear {
                    scrollViewProxy = proxy
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo("heatmap", anchor: .trailing)
                        }
                    }
                }
            }
            
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

#Preview {
    ReminderHeatmapView()
}
