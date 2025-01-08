import SwiftUI

struct HeatmapGridView: View {
    let data: [Date: Int]
    let year: Int
    @Binding var selectedDate: Date?
    @Binding var isSelected: Bool
    
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
                                isSelected = false
                            } else {
                                selectedDate = date
                                isSelected = true
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(selectedDate == date ? Color.blue : Color.clear, lineWidth: 2)
                    )
            }
        }
            .padding(.horizontal, 3)
    }
    
    private func getDatesGrid() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = 1
        dateComponents.day = 1
        let startDate = calendar.date(from: dateComponents)!
        
        dateComponents.year = year
        dateComponents.month = 12
        dateComponents.day = 31
        let yearEndDate = calendar.date(from: dateComponents)!
        
        let endDate = min(today, yearEndDate)
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while calendar.component(.weekday, from: currentDate) != 1 {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        var adjustedEndDate = endDate
        while calendar.component(.weekday, from: adjustedEndDate) != 7 {
            adjustedEndDate = calendar.date(byAdding: .day, value: 1, to: adjustedEndDate)!
        }
        
        while currentDate <= adjustedEndDate {
            if currentDate <= today {
                dates.append(currentDate)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        let weeks = stride(from: 0, to: dates.count, by: 7).map {
            Array(dates[($0)..<min($0 + 7, dates.count)])
        }
        
        var sortedDates: [Date] = []
        for column in 0..<weeks.count {
            for row in 0..<7 {
                if column < weeks.count && row < weeks[column].count {
                    sortedDates.append(weeks[column][row])
                }
            }
        }
        
        return sortedDates
    }
    
    private func colorForDate(_ date: Date) -> Color {
        let calendar = Calendar.current
        let selectedYear = calendar.component(.year, from: date)
        
        if selectedYear < year || selectedYear > year {
            return Color(.systemGray2)
        }
        
        let count = data[Calendar.current.startOfDay(for: date)] ?? 0
        
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
