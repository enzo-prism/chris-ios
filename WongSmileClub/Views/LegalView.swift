import SwiftUI

struct LegalView: View {
    let title: String
    let bodyText: String

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                GlassCard {
                    Text(bodyText)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationTitle(title)
    }
}
