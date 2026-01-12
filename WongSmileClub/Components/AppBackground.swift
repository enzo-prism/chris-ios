import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.92, green: 0.95, blue: 0.98),
                Color(red: 0.88, green: 0.92, blue: 0.96),
                Color(red: 0.95, green: 0.94, blue: 0.97)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
