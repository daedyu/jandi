import SwiftUI

struct HeatmapGridView: View {
    let data: [Date: Int]
    @Binding var selectedDate: Date?
    
    private let columns = Array(repeating: GridItem(.fixed(20)), count: 53)
    private let rows = 7
    
    var body: some View {
        LazyHGrid(rows: Array(repeating: GridItem(.fixed(20)), count: rows), spacing: 4) {
            ForEach(getDatesGrid(), id: \.self) { date in
                RoundedRectangle(cornerRadius: 2)
                    .fill(colorForDate(date))
                    .frame(width: 16, height: 16)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if selectedDate == date {
                                selectedDate = nil
                            } else {
                                selectedDate = date
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(selectedDate == date ? Color.blue : Color.clear, lineWidth: 2)
                    )
            }
        }
        .padding(.horizontal)
    }
    
    private func getDatesGrid() -> [Date] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -1, to: endDate)!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    private func colorForDate(_ date: Date) -> Color {
        let count = data[Calendar.current.startOfDay(for: date)] ?? 0
        
        print(count)
        
        switch count {
        case 0:
            return Color(.systemGray6)
        case 1:
            return Color.green.opacity(0.2)
        case 2...3:
            return Color.green.opacity(0.4)
        case 4...6:
            return Color.green.opacity(0.6)
        default:
            return Color.green.opacity(0.8)
        }
    }
}
