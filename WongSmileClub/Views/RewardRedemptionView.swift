import SwiftUI
import SwiftData

struct RewardRedemptionView: View {
    @Query private var profiles: [UserProfile]
    @StateObject private var viewModel: RewardRedemptionViewModel
    @State private var showSuccess = false
    @State private var successMessage = ""

    let reward: Reward
    let currentBalance: Int

    init(reward: Reward, currentBalance: Int, config: AppConfig, formspree: FormspreeClientProtocol, pointsStore: PointsStore) {
        self.reward = reward
        self.currentBalance = currentBalance
        _viewModel = StateObject(wrappedValue: RewardRedemptionViewModel(config: config, formspree: formspree, pointsStore: pointsStore))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Redeem \(reward.title)")

                            Text("Cost: \(reward.pointsCost) points")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            TextField("Name", text: $viewModel.name)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Phone", text: $viewModel.phone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .textFieldStyle(.roundedBorder)

                            TextField("Email", text: $viewModel.email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)

                            TextField("Optional note", text: $viewModel.note, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Confirm Redemption", systemImage: "checkmark") {
                        Task {
                            await viewModel.submit(reward: reward, currentBalance: currentBalance)
                        }
                    }
                    .disabled(viewModel.status.isSubmitting || viewModel.name.isEmpty || viewModel.phone.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Redeem")
        .onAppear {
            guard let profile = profiles.first else { return }
            if viewModel.name.isEmpty { viewModel.name = profile.name }
            if viewModel.phone.isEmpty { viewModel.phone = profile.phone }
            if viewModel.email.isEmpty { viewModel.email = profile.email }
        }
        .onChange(of: viewModel.status) { _, status in
            if case .success(let message) = status {
                successMessage = message
                showSuccess = true
            }
        }
        .sheet(isPresented: $showSuccess) {
            SubmissionSuccessView(
                title: "Redemption Sent",
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
