import SwiftUI

struct YearPickerView: View {
    @Binding var selectedYear: Int
    let yearRange: [Int]
    @State private var showPicker = false
    
    var body: some View {
        HStack {
            Text("미리알림 완료 히스토리")
                .font(.headline)
            Spacer()
            Button(action: {
                showPicker = true
            }) {
                HStack {
                    Text("\(selectedYear)")
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
            }
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                HStack {
                    Button("취소") {
                        showPicker = false
                    }
                    Spacer()
                    Button("완료") {
                        showPicker = false
                    }
                }
                .padding()
                
                Picker("년도", selection: $selectedYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text("\(year)")
                    }
                }
                .pickerStyle(.wheel)
            }
            .presentationDetents([.height(250)])
        }
    }
}
