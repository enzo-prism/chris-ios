import SwiftUI

struct EarnView: View {
    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                EarnContentView()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .navigationTitle("Earn")
    }
}
