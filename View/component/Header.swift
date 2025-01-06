import SwiftUI

struct Header: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                print("Settings tapped")
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding([.top, .horizontal])
        .background(Color.gray.opacity(0.1))
    }
}
