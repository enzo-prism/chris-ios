import SwiftUI

struct EmergencyView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Emergency Care")
                            .font(.system(.title2, design: .rounded).weight(.bold))

                        Text("If this is life-threatening, call 911 immediately.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        PrimaryButton(title: "Call Now", systemImage: "phone.fill") {
                            if let url = config.phoneURL {
                                openURL(url)
                            }
                        }
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Directions")
                            .font(.headline)
                        Text(config.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Button {
                            if let url = config.mapsURL {
                                openURL(url)
                            }
                        } label: {
                            Label("Open in Maps", systemImage: "map.fill")
                                .font(.system(.headline, design: .rounded))
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Office Hours")
                            .font(.headline)
                        ForEach(config.practiceHours, id: \.self) { hour in
                            Text(hour)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .navigationTitle("Emergency")
    }
}
