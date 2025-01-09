import EventKit
import SwiftUI
import Foundation

class ReminderHeatmapViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var completionData: [Date: Int] = [:]
    @Published var selectedDate: Date?
    @Published var isAgreed: Bool = false
    
    func requestAccess() {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToReminders { [weak self] granted, error in
                DispatchQueue.main.async {
                    if granted {
                        self?.fetchCompletedReminders()
                        self?.isAgreed = false
                    } else {
                        self?.isAgreed = true
                    }
                }
            }
        } else {
            eventStore.requestAccess(to: .reminder) { [weak self] granted, error in
                DispatchQueue.main.async {
                    if granted {
                        self?.fetchCompletedReminders()
                    }
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
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
