import SwiftUI

struct YearMonthLabelsView: View {
    private let calendar = Calendar.current
    
    var body: some View {
        let dates = getMonthLabels()
        
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(dates, id: \.self) { date in
                let isFirstOfYear = calendar.component(.month, from: date) == 1
                
                if isFirstOfYear {
                    Text("\(calendar.component(.year, from: date))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .leading)
                }
                
                Text(monthLabel(for: date))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                    .padding(.leading, isFirstOfYear ? 0 : 4)
            }
        }
    }
    
    private func getMonthLabels() -> [Date] {
        let endDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -1, to: endDate)!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            if calendar.component(.day, from: currentDate) == 1 {
                dates.append(currentDate)
            }
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    private func monthLabel(for date: Date) -> String {
        let month = calendar.component(.month, from: date)
        return "\(month)"
    }
}
