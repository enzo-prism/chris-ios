import SwiftUI

struct CommunityGuidelinesView: View {
    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Community Guidelines", systemImage: AppSymbol.guidelines)
                            Text("We review submissions before sharing. Please follow these rules:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            guidelinesList
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Guidelines")
    }

    private var guidelinesList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("• Only submit content you own or have permission to share.")
            Text("• No nudity, violence, or illegal content.")
            Text("• Do not include third-party medical details.")
            Text("• Respect patient privacy and consent.")
            Text("• Submissions may be edited or declined.")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
}
