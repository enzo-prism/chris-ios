import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var consentRepost = false
    @State private var consentMarketing = false
    @State private var loadedProfile = false

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Your Profile", systemImage: AppSymbol.profile)

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

                            PrimaryButton(title: "Save Profile", systemImage: AppSymbol.confirm) {
                                saveProfile()
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
}
