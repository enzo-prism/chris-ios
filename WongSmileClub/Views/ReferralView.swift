import SwiftUI
import SwiftData

struct ReferralView: View {
    @Query private var profiles: [UserProfile]
    @StateObject private var viewModel: ReferralViewModel
    @State private var showSuccess = false
    @State private var successMessage = ""

    init(pointsStore: PointsStore, config: AppConfig, formspree: FormspreeClientProtocol) {
        _viewModel = StateObject(wrappedValue: ReferralViewModel(config: config, formspree: formspree, pointsStore: pointsStore))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Refer a Friend")

                            TextField("Your name", text: $viewModel.yourName)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Your phone", text: $viewModel.yourPhone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .textFieldStyle(.roundedBorder)

                            TextField("Your email", text: $viewModel.yourEmail)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)

                            Divider().padding(.vertical, 4)

                            TextField("Friend's name", text: $viewModel.friendName)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Friend's phone", text: $viewModel.friendPhone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .textFieldStyle(.roundedBorder)

                            TextField("Friend's email", text: $viewModel.friendEmail)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)

                            TextField("Why they would be a good fit", text: $viewModel.whyGoodFit, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Toggle("I have permission to share my friend's contact info.", isOn: $viewModel.hasPermission)

                            Text("Do not include medical details; we will call you.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Submit Referral", systemImage: "person.badge.plus") {
                        Task {
                            await viewModel.submit()
                        }
                    }
                    .disabled(viewModel.status.isSubmitting || viewModel.yourName.isEmpty || viewModel.yourPhone.isEmpty || viewModel.friendName.isEmpty || !viewModel.hasPermission)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Referral")
        .onAppear {
            guard let profile = profiles.first else { return }
            if viewModel.yourName.isEmpty { viewModel.yourName = profile.name }
            if viewModel.yourPhone.isEmpty { viewModel.yourPhone = profile.phone }
            if viewModel.yourEmail.isEmpty { viewModel.yourEmail = profile.email }
        }
        .onChange(of: viewModel.status) { _, status in
            if case .success(let message) = status {
                successMessage = message
                showSuccess = true
            }
        }
        .sheet(isPresented: $showSuccess) {
            SubmissionSuccessView(
                title: "Referral Submitted",
                message: successMessage,
                systemImage: "checkmark.seal.fill"
            )
        }
        .alert("Submission Failed", isPresented: Binding(get: {
            viewModel.status.errorMessage != nil
        }, set: { _ in
            viewModel.status = .idle
        })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.status.errorMessage ?? "")
        }
    }
}
