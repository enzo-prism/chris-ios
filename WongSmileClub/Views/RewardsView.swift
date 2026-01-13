import SwiftUI

struct RewardsView: View {
    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                RewardsContentView()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .navigationTitle("Rewards")
    }
}
