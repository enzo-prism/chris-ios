import SwiftUI

struct OfferDetailView: View {
    let offer: Offer
    @State private var showSafari = false

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(offer.title)
                            .font(.system(.title2, design: .rounded).weight(.bold))

                        Text(offer.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Why Dr. Wong recommends it")
                            .font(.headline)
                        Text(offer.recommendation)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Partner: \(offer.partner)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Text("Ends \(offer.endDateText)")
                            .font(.footnote)
                            .foregroundStyle(offer.isExpired ? .secondary : .primary)

                        if !offer.promoCode.isEmpty {
                            Text("Promo code: \(offer.promoCode)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        if offer.isExpired {
                            Text("This offer has expired.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Button {
                    showSafari = true
                } label: {
                    PrimaryButtonLabel(title: "Shop Offer", systemImage: AppSymbol.shop)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(offer.isExpired || offer.urlValue == nil)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .navigationTitle("Offer")
        .sheet(isPresented: $showSafari) {
            if let url = offer.urlValue {
                SafariView(url: url)
            }
        }
    }
}
