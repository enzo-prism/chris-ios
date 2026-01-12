import SwiftUI

struct OfferCardView: View {
    let offer: Offer

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(offer.title)
                        .font(.system(.headline, design: .rounded))
                    Spacer()
                    if offer.isExpired {
                        Text("Expired")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(offer.partner)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(offer.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                Text("Ends \(offer.endDateText)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
