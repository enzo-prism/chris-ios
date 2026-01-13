import SwiftUI

struct ReportConcernView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel: ReportConcernViewModel
    @State private var showSuccess = false
    @State private var successMessage = ""

    init(config: AppConfig, formspree: FormspreeClientProtocol) {
        _viewModel = StateObject(wrappedValue: ReportConcernViewModel(config: config, formspree: formspree))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Report a Concern", systemImage: AppSymbol.report)

                            TextField("Name (optional)", text: $viewModel.name)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Phone or email (optional)", text: $viewModel.contact)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textFieldStyle(.roundedBorder)

                            Picker("Category", selection: $viewModel.category) {
                                ForEach(ReportConcernViewModel.Category.allCases) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }

                            TextField("Describe the concern", text: $viewModel.description, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Text("Do not include medical details; we will call you if needed.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Submit Report", systemImage: AppSymbol.submit) {
                        Task {
                            await viewModel.submit()
                        }
                    }
                    .disabled(viewModel.status.isSubmitting || config.reportConcernEndpoint == nil)

                    if config.reportConcernEndpoint == nil {
                        supportFallbackCard
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Report a Concern")
        .onChange(of: viewModel.status) { _, status in
            if case .success(let message) = status {
                successMessage = message
                showSuccess = true
            }
        }
        .sheet(isPresented: $showSuccess) {
            SubmissionSuccessView(
                title: "Report Sent",
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

    private var supportFallbackCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Reporting isn’t configured yet. Please contact support.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                if let emailURL = config.supportEmailURL {
                    Button {
                        openURL(emailURL)
                    } label: {
                        AppLabel(
                            title: "Email support",
                            systemImage: AppSymbol.support,
                            textFont: .system(.subheadline, design: .rounded)
                        )
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("Support email: \(config.supportEmailDisplay)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let phoneURL = config.phoneURL {
                    Button {
                        openURL(phoneURL)
                    } label: {
                        AppLabel(
                            title: "Call the office",
                            systemImage: AppSymbol.call,
                            textFont: .system(.subheadline, design: .rounded)
                        )
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
