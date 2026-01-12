import SwiftUI

struct OfferCardView: View {
    let offer: Offer

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    IconBadge(systemImage: AppSymbol.offers)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(offer.title)
                            .font(.system(.headline, design: .rounded))
                        Text(offer.partner)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if offer.isExpired {
                        Text("Expired")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

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
