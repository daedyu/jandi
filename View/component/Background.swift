import SwiftUI

struct BackgroundUI: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if colorScheme == .dark {
            Color(.black)
        } else {
            Color(.secondarySystemBackground)
        }
    }
}
