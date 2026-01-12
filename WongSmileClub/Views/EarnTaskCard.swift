import SwiftUI

struct EarnTaskCard: View {
    let title: String
    let description: String
    let systemImage: String
    let points: Int?
    let footnote: String?

    var body: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 44)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(title)
                            .font(.system(.headline, design: .rounded))
                        Spacer()
                        if let points {
                            PointsPill(points: points)
                        }
                    }

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if let footnote, !footnote.isEmpty {
                        Text(footnote)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
