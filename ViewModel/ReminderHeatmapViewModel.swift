import EventKit
import SwiftUI

class ReminderHeatmapViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var completionData: [Date: Int] = [:]
    
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
        
        let predicate = eventStore.predicateForReminders(in: nil)
        
        eventStore.fetchReminders(matching: predicate) { reminders in
            guard let reminders = reminders else { return }
            
            var dailyCount: [Date: Int] = [:]
            
            for reminder in reminders {
                if let completionDate = reminder.completionDate,
                   completionDate >= startDate && completionDate <= endDate {
                    let dateKey = Calendar.current.startOfDay(for: completionDate)
                    dailyCount[dateKey, default: 0] += 1
                }
            }
            
            DispatchQueue.main.async {
                self.completionData = dailyCount
            }
        }
    }
}
