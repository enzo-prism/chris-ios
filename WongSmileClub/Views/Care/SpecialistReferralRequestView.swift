import SwiftUI
import SwiftData

struct SpecialistReferralRequestView: View {
    @Query private var profiles: [UserProfile]
    @StateObject private var viewModel: SpecialistReferralRequestViewModel
    @State private var showSuccess = false
    @State private var successMessage = ""

    init(specialists: [Specialist], selectedSpecialist: Specialist?, config: AppConfig, formspree: FormspreeClientProtocol) {
        _viewModel = StateObject(wrappedValue: SpecialistReferralRequestViewModel(
            specialists: specialists,
            selectedSpecialist: selectedSpecialist,
            config: config,
            formspree: formspree
        ))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Request Coordination", systemImage: AppSymbol.specialists)

                            TextField("Your name", text: $viewModel.patientName)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Phone or email", text: $viewModel.patientContact)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textFieldStyle(.roundedBorder)

                            Picker("Specialist", selection: $viewModel.selectedSpecialistId) {
                                ForEach(viewModel.specialists) { specialist in
                                    Text("\(specialist.name) - \(specialist.category)")
                                        .tag(specialist.id)
                                }
                            }

                            Picker("Reason", selection: $viewModel.reason) {
                                ForEach(SpecialistReferralRequestViewModel.ReferralReason.allCases) { reason in
                                    Text(reason.rawValue).tag(reason)
                                }
                            }

                            Picker("Preferred time", selection: $viewModel.preferredTime) {
                                ForEach(viewModel.preferredTimes, id: \.self) { time in
                                    Text(time)
                                }
                            }
                            .pickerStyle(.segmented)

                            TextField("Optional note (no medical details)", text: $viewModel.note, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Toggle("I consent to be contacted about this referral", isOn: $viewModel.hasConsent)

                            Text("Do not include medical details; we will call you.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Request Coordination", systemImage: AppSymbol.submit) {
                        Task {
                            await viewModel.submit()
                        }
                    }
                    .disabled(viewModel.status.isSubmitting || viewModel.patientName.isEmpty || viewModel.patientContact.isEmpty || viewModel.selectedSpecialistId.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Coordination Request")
        .onAppear {
            guard let profile = profiles.first else { return }
            if viewModel.patientName.isEmpty { viewModel.patientName = profile.name }
            if viewModel.patientContact.isEmpty {
                viewModel.patientContact = profile.email.isEmpty ? profile.phone : profile.email
            }
        }
        .onChange(of: viewModel.status) { _, status in
            if case .success(let message) = status {
                successMessage = message
                showSuccess = true
            }
        }
        .sheet(isPresented: $showSuccess) {
            SubmissionSuccessView(
                title: "Request Sent",
                message: successMessage,
                systemImage: AppSymbol.success
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
