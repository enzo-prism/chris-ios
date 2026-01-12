import SwiftUI
import SwiftData

struct AppointmentRequestView: View {
    @Query private var profiles: [UserProfile]
    @StateObject private var viewModel: AppointmentRequestViewModel
    @State private var showSuccess = false
    @State private var successMessage = ""

    init(config: AppConfig, formspree: FormspreeClientProtocol) {
        _viewModel = StateObject(wrappedValue: AppointmentRequestViewModel(config: config, formspree: formspree))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Appointment Request", systemImage: AppSymbol.book)

                            TextField("Full name", text: $viewModel.fullName)
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

                            DatePicker("Preferred day", selection: $viewModel.preferredDate, displayedComponents: .date)
                                .datePickerStyle(.compact)

                            Picker("Preferred time", selection: $viewModel.preferredTime) {
                                ForEach(viewModel.preferredTimes, id: \.self) { time in
                                    Text(time).tag(time)
                                }
                            }
                            .pickerStyle(.segmented)

                            Picker("Appointment type", selection: $viewModel.appointmentType) {
                                ForEach(AppointmentRequestViewModel.AppointmentType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Notes (optional)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                TextEditor(text: $viewModel.notes)
                                    .frame(minHeight: 90)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2)))
                            }

                            Text("Do not include medical details; we will call you.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Submit Request", systemImage: AppSymbol.submit) {
                        Task {
                            await viewModel.submit()
                        }
                    }
                    .disabled(viewModel.status.isSubmitting || viewModel.fullName.isEmpty || viewModel.phone.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Request")
        .onAppear {
            guard let profile = profiles.first else { return }
            if viewModel.fullName.isEmpty { viewModel.fullName = profile.name }
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
