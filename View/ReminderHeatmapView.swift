import SwiftUI
import EventKit

struct ReminderHeatmapView: View {
    @StateObject private var viewModel = ReminderHeatmapViewModel()
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isDateSelected: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HeatmapGridView(data: viewModel.completionData,
                               selectedDate: $viewModel.selectedDate,
                               isSelected: $isDateSelected)
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
            
            if let selectedDate = viewModel.selectedDate, isDateSelected {
                let count = viewModel.completionData[viewModel.getDate(selectedDate)] ?? 0
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
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDateSelected = false
                    }
                }
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
