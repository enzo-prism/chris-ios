import SwiftUI

struct FeedbackView: View {
    @StateObject private var viewModel: FeedbackViewModel
    @State private var showSuccess = false
    @State private var successMessage = ""

    let googleURL: URL?
    let yelpURL: URL?

    init(pointsStore: PointsStore, config: AppConfig, formspree: FormspreeClientProtocol) {
        _viewModel = StateObject(wrappedValue: FeedbackViewModel(config: config, formspree: formspree, pointsStore: pointsStore))
        googleURL = config.googleReviewURL
        yelpURL = config.yelpURL
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Private Feedback", systemImage: AppSymbol.feedback)

                            Picker("Rating", selection: $viewModel.rating) {
                                ForEach(1...5, id: \.self) { value in
                                    Text("\(value)")
                                }
                            }
                            .pickerStyle(.segmented)

                            TextField("What did we do well?", text: $viewModel.positives, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            TextField("What can we improve?", text: $viewModel.improvements, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Text("Do not include medical details; we will call you.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Submit Feedback", systemImage: AppSymbol.submit) {
                        Task {
                            await viewModel.submit()
                        }
                    }
                    .disabled(viewModel.status.isSubmitting)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Feedback")
        .onChange(of: viewModel.status) { _, status in
            if case .success(let message) = status {
                successMessage = message
                showSuccess = true
            }
        }
        .sheet(isPresented: $showSuccess) {
            FeedbackSuccessView(message: successMessage, googleURL: googleURL, yelpURL: yelpURL)
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
