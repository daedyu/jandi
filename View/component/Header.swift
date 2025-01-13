import SwiftUI

struct ScrollDetectingView: UIViewRepresentable {
    let onScroll: (CGFloat) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.delegate = context.coordinator
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onScroll: onScroll)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let onScroll: (CGFloat) -> Void
        
        init(onScroll: @escaping (CGFloat) -> Void) {
            self.onScroll = onScroll
            super.init()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onScroll(scrollView.contentOffset.y)
        }
    }
}

struct Header: View {
    @State private var scrollOffset: CGFloat = 0
    private let maxOpacity: Double = 0.1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    ScrollDetectingView { offset in
                        scrollOffset = offset
                    }
                    
                    VStack {
                        // 스크롤 가능한 컨텐츠를 위한 더미 뷰
                        ForEach(0..<20) { i in
                            Text("Item \(i)")
                                .frame(height: 44)
                        }
                    }
                    .padding(.top, 1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // 설정 액션
                        }) {
                            Label("설정", systemImage: "gear")
                        }
                        Button(action: {
                            // 목록 관리 액션
                        }) {
                            Label("목록 관리", systemImage: "folder")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
            .toolbarBackground(Color(.systemBackground).opacity(headerOpacity), for: .navigationBar)
        }
    }
    
    private var headerOpacity: Double {
        let threshold: CGFloat = 64
        if scrollOffset <= 0 {
            return 0
        } else if scrollOffset >= threshold {
            return maxOpacity
        } else {
            return (scrollOffset / threshold) * maxOpacity
        }
    }
}

#Preview {
    Header()
}
