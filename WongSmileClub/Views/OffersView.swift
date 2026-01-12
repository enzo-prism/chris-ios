import SwiftUI

struct OffersView: View {
    @EnvironmentObject private var dataStore: AppDataStore

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    SectionHeader(title: "Limited-Time Offers", systemImage: AppSymbol.offers)

                    ForEach(dataStore.offers) { offer in
                        NavigationLink {
                            OfferDetailView(offer: offer)
                        } label: {
                            OfferCardView(offer: offer)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Offers")
    }
}
