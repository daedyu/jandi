import SwiftUI

struct ContentView: View {
    @StateObject private var remindersManager = RemindersManager()
    @State private var hasAccess: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                if hasAccess {
                    Text("완료한 미리 알림 개수: \(remindersManager.completedCount)")
                        .font(.headline)
                        .padding()
                        .onAppear {
                            remindersManager.fetchCompletedReminders()
                        }
                } else {
                    Text("미리 알림 데이터 접근 권한이 필요합니다.")
                        .multilineTextAlignment(.center)
                        .padding()
//                    Button("권한 요청") {
//                        remindersManager.requestAccess { granted in
//                            self.hasAccess = granted
//                            if granted {
//                                remindersManager.fetchCompletedReminders()
//                            }
//                        }
//                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Apple 미리 알림")
        }
        .onAppear {
            remindersManager.requestAccess { granted in
                self.hasAccess = granted
                if granted {
                    remindersManager.fetchCompletedReminders()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
