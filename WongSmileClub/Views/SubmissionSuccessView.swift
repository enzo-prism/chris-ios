import SwiftUI

struct SubmissionSuccessView: View {
    let title: String
    let message: String
    let systemImage: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                AppIcon(name: systemImage, size: AppIconSize.hero, weight: .bold, color: .accentColor)

                Text(title)
                    .font(.system(.title2, design: .rounded).weight(.bold))

                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                PrimaryButton(title: "Done", systemImage: AppSymbol.confirm) {
                    dismiss()
                }
            }
            .padding(24)
        }
    }
}
