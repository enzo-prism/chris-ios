import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PointsTransaction.date, order: .reverse) private var transactions: [PointsTransaction]
    @Query private var profiles: [UserProfile]

    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var consentRepost = false
    @State private var consentMarketing = false
    @State private var loadedProfile = false

    private var balance: Int {
        PointsSummary.balance(from: transactions)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Your Profile")

                            TextField("Name", text: $name)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Phone", text: $phone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .textFieldStyle(.roundedBorder)

                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)

                            Toggle("Consent to repost submitted media", isOn: $consentRepost)
                            Toggle("Consent to marketing updates", isOn: $consentMarketing)

                            PrimaryButton(title: "Save Profile", systemImage: "checkmark") {
                                saveProfile()
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Points History")
                            Text("Current balance: \(balance)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            ForEach(transactions) { transaction in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(sourceLabel(for: transaction.source))
                                            .font(.subheadline)
                                        Text(DateFormatter.shortDateTime.string(from: transaction.date))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(transaction.displayPoints)
                                        .font(.subheadline)
                                        .foregroundStyle(transaction.type == .redeem ? .secondary : .primary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Practice Info")
                            Text(config.practiceName)
                                .font(.headline)
                            Text(config.address)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(config.phone)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let url = config.websiteURL {
                                Link("Visit Website", destination: url)
                            }

                            ForEach(config.practiceHours, id: \.self) { hour in
                                Text(hour)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Legal")
                            NavigationLink("Terms of Service") {
                                LegalView(title: "Terms", bodyText: "TODO: Add terms of service.")
                            }
                            NavigationLink("Privacy Policy") {
                                LegalView(title: "Privacy", bodyText: "TODO: Add privacy policy.")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            if loadedProfile { return }
            loadedProfile = true
            if let profile = profiles.first {
                name = profile.name
                phone = profile.phone
                email = profile.email
                consentRepost = profile.consentRepost
                consentMarketing = profile.consentMarketing
            } else {
                let newProfile = UserProfile()
                modelContext.insert(newProfile)
                name = newProfile.name
                phone = newProfile.phone
                email = newProfile.email
            }
        }
    }

    private func saveProfile() {
        let profile: UserProfile
        if let existing = profiles.first {
            profile = existing
        } else {
            profile = UserProfile()
            modelContext.insert(profile)
        }
        profile.name = name
        profile.phone = phone
        profile.email = email
        profile.consentRepost = consentRepost
        profile.consentMarketing = consentMarketing
        try? modelContext.save()
    }

    private func sourceLabel(for source: PointsTransaction.Source) -> String {
        switch source {
        case .referral: return "Referral"
        case .photo: return "Smile photo"
        case .video: return "Smile video"
        case .instagram: return "Instagram"
        case .feedback: return "Private feedback"
        case .appointment: return "Appointment"
        case .rewardRedemption: return "Reward redemption"
        case .publicReviewGoogle: return "Google review"
        case .publicReviewYelp: return "Yelp review"
        case .other: return "Other"
        }
    }
}
