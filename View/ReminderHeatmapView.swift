import SwiftUI
import EventKit

struct ReminderHeatmapView: View {
    @StateObject private var viewModel = ReminderHeatmapViewModel()
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isDateSelected: Bool = true
    @State private var isPickerPresented = false
    @State var selectedYear: Int = 2025
    var yearRange = Array(1900...2300)
    
    var body: some View {
        ZStack {
            BackgroundUI().ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 15) {
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
                        YearPickerView(selectedYear: $selectedYear, yearRange: yearRange)
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HeatmapGridView(
                                    data: viewModel.completionData,
                                    year: selectedYear,
                                    selectedDate: $viewModel.selectedDate,
                                    isSelected: $isDateSelected
                                )
                                .frame(height: 200)
                                .id("heatmap")
                            }
                            .onChange(of: selectedYear) {
                                scrollViewProxy = proxy
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        proxy.scrollTo("heatmap", anchor: .trailing)
                                    }
                                }
                            }
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    scrollViewProxy = proxy
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            proxy.scrollTo("heatmap", anchor: .trailing)
                                        }
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
                                    viewModel.selectedDate = nil
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
            }
            .refreshable {
                viewModel.requestAccess()
            }

            .padding()
            .onAppear {
                viewModel.requestAccess()
            }
        }
        .alert(isPresented: $viewModel.isAgreed) {
            Alert(
                title: Text("미리알림 접근 권한 비활성화됨"),
                message: Text("미리알림의 접근 권한이 비활성화 되어 있어 자료를 불러올 수 없습니다. 미리알림 접근 권한을 활성화 해주세요")
            )
        }
    }
}

#Preview {
    ReminderHeatmapView()
}
