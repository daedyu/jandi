import SwiftUI
import EventKit

struct ReminderHeatmapView: View {
    @StateObject private var viewModel = ReminderHeatmapViewModel()
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isDateSelected: Bool = true
    
    var body: some View {
        ZStack {
            BackgroundUI().ignoresSafeArea()
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("미리알림 지속일")
                            .font(.headline)
                        Spacer()
                    }
                    
                    DurationView(data: viewModel.completionData)
                }
                .padding(20)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(18)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("미리알림 완료 히스토리")
                            .font(.headline)
                        Spacer()
                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 4) {
                                YearMonthLabelsView()
                                    .padding(.leading, 16)
                                
                                HeatmapGridView(
                                    data: viewModel.completionData,
                                    selectedDate: $viewModel.selectedDate,
                                    isSelected: $isDateSelected
                                )
                                    .frame(height: 200)
                            } .id("heatmap")
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
                        .cornerRadius(12)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isDateSelected = false
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(18)
                
                Spacer()
            }

            .padding()
            .onAppear {
                viewModel.requestAccess()
            }
        }
    }
}

#Preview {
    ReminderHeatmapView()
}
