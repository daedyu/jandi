import SwiftUI

struct DurationView: View {
    let data: [Date: Int]
    @AppStorage("score") private var maxDurateDate: Int?
    @State private var isDurated: Bool = true
    @State private var did: Bool = true
    
    var body: some View {
        if did {
            Text("🔥 \(maxDurationDate())")
                .font(.largeTitle)
                .fontWeight(.bold)
            if !isDurated {
                Text("오늘도 실천")
            }
        } else {
            Text("빨리 계획을 실천하세요!")
        }
    }
    
    private func maxDurationDate() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) else {
            return 0
        }
        
        let sortedDates = data.keys.sorted(by: >)
        print("today: \(today), yesterday: \(yesterday)")
        print(sortedDates)
        
        if let firstDate = sortedDates.first {
            if firstDate == today {
                return countDuration(dates: sortedDates)
            } else if firstDate == yesterday {
                isDurated = false
                return countDuration(dates: sortedDates)
            } else {
                did = false
            }
        }
        
        return 0
    }
    
    private func countDuration(dates: [Date]) -> Int {
        var stack: Int = 0
        var nowDate: Date = dates.first!
        for date in dates {
            if date == nowDate {
                stack += 1
                nowDate = Calendar.current.date(byAdding: .minute, value: -1, to: nowDate)!
            } else {
                break
            }
        }
        
        return stack
    }
}
