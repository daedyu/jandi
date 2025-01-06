import EventKit
import SwiftUI
import Foundation

class ReminderHeatmapViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var completionData: [Date: Int] = [:]
    @Published var selectedDate: Date?
    
    func requestAccess() {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToReminders { granted, error in
                if granted {
                    self.fetchCompletedReminders()
                }
            }
        } else {
            eventStore.requestAccess(to: .reminder) { granted, error in
                if granted {
                    self.fetchCompletedReminders()
                }
            }
        }
    }
    
    func fetchCompletedReminders() {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate)!
        let calendar = Calendar.current
        
        let predicate = eventStore.predicateForCompletedReminders(withCompletionDateStarting: startDate,
                                                                ending: endDate,
                                                                calendars: nil)
        
        eventStore.fetchReminders(matching: predicate) { reminders in
            guard let reminders = reminders else { return }
            
            var dailyCount: [Date: Int] = [:]
            
            for reminder in reminders {
                if let completionDate = reminder.completionDate {
                    let dateKey = calendar.startOfDay(for: completionDate)
                    dailyCount[dateKey, default: 0] += 1
                }
            }
            
            DispatchQueue.main.async {
                self.completionData = dailyCount
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    func getDate(_ date:Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        return newDate
    }
}
