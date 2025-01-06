import EventKit

class RemindersManager: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var completedCount: Int = 0

    func requestAccess(completion: @escaping (Bool) -> Void) {
        print("asasdsaw")
        eventStore.requestFullAccessToReminders(completion: { granted, error in
            if let error = error {
                print("Error requesting access: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        })
    }

    func fetchCompletedReminders() {
        let predicate = eventStore.predicateForCompletedReminders(
            withCompletionDateStarting: nil,
            ending: nil,
            calendars: nil
        )
        eventStore.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.completedCount = reminders?.count ?? 0
            }
        }
    }
}
