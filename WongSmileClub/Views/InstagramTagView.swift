import SwiftUI
import SwiftData

struct InstagramTagView: View {
    @Query private var profiles: [UserProfile]
    @Environment(\.dismiss) private var dismiss

    let pointsStore: PointsStore

    @State private var name = ""
    @State private var contact = ""
    @State private var postLink = ""
    @State private var note = ""
    @State private var showSuccess = false

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Instagram Tag", systemImage: AppSymbol.instagram)

                            TextField("Your name", text: $name)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Phone or email", text: $contact)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textFieldStyle(.roundedBorder)

                            TextField("Post link (optional)", text: $postLink)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)

                            TextField("Optional note", text: $note, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Text("Do not include medical details; we will call you.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: "Claim Instagram Points", systemImage: AppSymbol.instagram) {
                        let metadata = PointsTransaction.metadata(from: [
                            "name": name,
                            "contact": contact,
                            "postLink": postLink,
                            "note": note
                        ])
                        pointsStore.addTransaction(PointsTransaction(type: .earn, source: .instagram, points: PointsValues.instagram, note: "Instagram tag", metadataJSON: metadata))
                        showSuccess = true
                    }
                    .disabled(name.isEmpty || contact.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Instagram")
        .onAppear {
            guard let profile = profiles.first else { return }
            if name.isEmpty { name = profile.name }
            if contact.isEmpty {
                contact = profile.email.isEmpty ? profile.phone : profile.email
            }
        }
        .sheet(isPresented: $showSuccess) {
            SubmissionSuccessView(
                title: "Submitted",
                message: "Thanks! We will verify at redemption.",
                systemImage: AppSymbol.success
            )
        }
    }
}
