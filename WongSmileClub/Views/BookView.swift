import SwiftUI

struct BookView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Environment(\.openURL) private var openURL
    @State private var showScheduling = false
    @State private var schedulingURL: URL?
    @State private var showSchedulingAlert = false

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 20) {
                    SectionHeader(title: "Book Your Visit", systemImage: AppSymbol.book)

                    NavigationLink {
                        AppointmentRequestView(config: config, formspree: formspree)
                    } label: {
                        GlassCard {
                            bookingCardContent(
                                title: "Request Appointment",
                                subtitle: "Send a quick request and we will confirm.",
                                systemImage: AppSymbol.book
                            )
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        schedulingURL = config.schedulingURL
                        if schedulingURL != nil {
                            showScheduling = true
                        } else {
                            showSchedulingAlert = true
                        }
                    } label: {
                        GlassCard {
                            bookingCardContent(
                                title: "Online Scheduling",
                                subtitle: "Book instantly on our scheduling page.",
                                systemImage: AppSymbol.schedule
                            )
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        if let url = config.phoneURL {
                            openURL(url)
                        }
                    } label: {
                        GlassCard {
                            bookingCardContent(
                                title: "Call Office",
                                subtitle: config.phoneDisplay,
                                systemImage: AppSymbol.call
                            )
                        }
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        EmergencyView()
                    } label: {
                        PrimaryButtonLabel(title: "Emergency", systemImage: AppSymbol.emergency)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Book")
        .sheet(isPresented: $showScheduling) {
            if let schedulingURL {
                SafariView(url: schedulingURL)
            }
        }
        .alert("Scheduling Unavailable", isPresented: $showSchedulingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Online scheduling is not configured yet. Call the office to book.")
        }
    }

    private func bookingCardContent(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 16) {
            IconBadge(systemImage: systemImage)
                .frame(width: 44)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
