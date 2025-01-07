import SwiftUI

struct DurationView: View {
    let data: [Date: Int]
    
    var durationState: (count: Int, isDurated: Bool, did: Bool) {
        let today = Calendar.current.startOfDay(for: Date())
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) else {
            return (0, true, true)
        }
        
        let sortedDates = data.keys.sorted(by: >)
        
        guard let firstDate = sortedDates.first else {
            return (0, true, true)
        }
        
        if firstDate == today {
            return (countDuration(dates: sortedDates), true, true)
        } else if firstDate == yesterday {
            return (countDuration(dates: sortedDates), false, true)
        } else {
            return (0, true, false)
        }
    }
    
    var body: some View {
        if durationState.did {
            Text("🔥 \(durationState.count)")
                .font(.largeTitle)
                .fontWeight(.bold)
            if !durationState.isDurated {
                Text("오늘도 실천하세요!!")
            }
        } else {
            Text("빨리 계획을 실천하세요!!")
        }
    }
    
    private func countDuration(dates: [Date]) -> Int {
        var stack: Int = 0
        var nowDate: Date = dates.first!
        for date in dates {
            if date == nowDate {
                stack += 1
                nowDate = Calendar.current.date(byAdding: .minute, value: -1440, to: nowDate)!
            } else {
                break
            }
        }
        
        return stack
    }
}
