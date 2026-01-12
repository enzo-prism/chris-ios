import SwiftUI

struct SectionHeader: View {
    let title: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 8) {
            if let systemImage {
                AppIcon(name: systemImage, size: AppIconSize.inline, weight: .semibold, color: .accentColor)
                    .accessibilityHidden(true)
            }

            Text(title)
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
