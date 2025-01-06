import Foundation

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    var completed: Bool
}
