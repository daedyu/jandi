import SwiftUI
import EventKit

struct ReminderItem: Identifiable {
    let id: String
    let title: String
    let dueDate: Date?
    let reminder: EKReminder
    var isCompleted: Bool
}

struct TodayRemindersView: View {
    @State private var remainingReminders: Int = 0
    @State private var selectedList: EKCalendar?
    @State private var availableLists: [EKCalendar] = []
    @State private var reminderItems: [ReminderItem] = []
    private let eventStore = EKEventStore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !availableLists.isEmpty {
                Picker("목록 선택", selection: $selectedList) {
                    Text("전체 목록").tag(Optional<EKCalendar>.none)
                    ForEach(availableLists, id: \.calendarIdentifier) { list in
                        Text(list.title)
                            .tag(Optional(list))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
            }
            
            HStack {
                Image(systemName: "list.bullet.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(selectedList?.title ?? "전체 목록")
                    .font(.headline)
                
                Spacer()
                
                Text("\(remainingReminders)개")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding()
            VStack {
                ForEach(reminderItems) { item in
                    ReminderRowView(item: item)
                }
            }
        }
        .padding()
        .onAppear {
            requestRemindersAccess()
        }
        .onChange(of: selectedList) { oldValue, newValue in
            fetchTodayReminders()
        }
    }
    
    private func requestRemindersAccess() {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToReminders { granted, error in
                if granted {
                    loadAvailableLists()
                    fetchTodayReminders()
                }
            }
        } else {
            eventStore.requestAccess(to: .reminder) { granted, error in
                if granted {
                    loadAvailableLists()
                    fetchTodayReminders()
                }
            }
        }
    }
    
    private func loadAvailableLists() {
        let calendars = eventStore.calendars(for: .reminder)
        DispatchQueue.main.async {
            self.availableLists = calendars
        }
    }
    
    private func fetchTodayReminders() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = selectedList != nil ?
            eventStore.predicateForReminders(in: [selectedList!]) :
            eventStore.predicateForReminders(in: nil)
        
        eventStore.fetchReminders(matching: predicate) { reminders in
            guard let reminders = reminders else { return }
            
            let todayReminders = reminders.filter { reminder in
                guard let dueDate = reminder.dueDateComponents?.date else { return false }
                return !reminder.isCompleted &&
                    dueDate >= startDate &&
                    dueDate < endDate
            }
            
            let items = todayReminders.map { reminder in
                ReminderItem(
                    id: reminder.calendarItemIdentifier,
                    title: reminder.title,
                    dueDate: reminder.dueDateComponents?.date,
                    reminder: reminder,
                    isCompleted: reminder.isCompleted
                )
            }
            
            DispatchQueue.main.async {
                self.reminderItems = items
                self.remainingReminders = items.count
            }
        }
    }
}

struct ReminderRowView: View {
    let item: ReminderItem
    
    var body: some View {
        HStack {            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                
                if let dueDate = item.dueDate {
                    Text(formatDate(dueDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    TodayRemindersView()
}
