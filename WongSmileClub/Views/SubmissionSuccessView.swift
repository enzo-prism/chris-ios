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
                Image(systemName: systemImage)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color.accentColor)

                Text(title)
                    .font(.system(.title2, design: .rounded).weight(.bold))

                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                PrimaryButton(title: "Done", systemImage: "checkmark") {
                    dismiss()
                }
            }
            .padding(24)
        }
    }
}
