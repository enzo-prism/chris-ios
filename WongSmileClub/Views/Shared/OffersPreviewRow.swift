import SwiftUI

struct OffersPreviewRow: View {
    @EnvironmentObject private var dataStore: AppDataStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Limited-Time Offers", systemImage: AppSymbol.offers)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(dataStore.offers.prefix(5)) { offer in
                        NavigationLink {
                            OfferDetailView(offer: offer)
                        } label: {
                            OfferCardView(offer: offer)
                                .frame(width: 250)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}
