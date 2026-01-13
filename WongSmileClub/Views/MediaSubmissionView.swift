import PhotosUI
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct MediaSubmissionView: View {
    @Query private var profiles: [UserProfile]
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @StateObject private var viewModel: MediaSubmissionViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedData: Data?
    @State private var selectedFileName: String = ""
    @State private var selectedMimeType: String = "application/octet-stream"
    @State private var showSuccess = false
    @State private var successMessage = ""

    init(mediaType: MediaType, pointsStore: PointsStore, config: AppConfig, formspree: FormspreeClientProtocol) {
        _viewModel = StateObject(wrappedValue: MediaSubmissionViewModel(mediaType: mediaType, config: config, formspree: formspree, pointsStore: pointsStore))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(
                                title: "Submit \(viewModel.mediaType.title)",
                                systemImage: viewModel.mediaType == .photo ? AppSymbol.photo : AppSymbol.video
                            )

                            TextField("Your name", text: $viewModel.name)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)

                            TextField("Phone or email", text: $viewModel.contact)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textFieldStyle(.roundedBorder)

                            PhotosPicker(
                                selection: $selectedItem,
                                matching: viewModel.mediaType == .photo ? .images : .videos,
                                photoLibrary: .shared()) {
                                    AppLabel(
                                        title: "Select \(viewModel.mediaType == .photo ? "Photo" : "Video")",
                                        systemImage: AppSymbol.selectMedia,
                                        iconSize: AppIconSize.inline,
                                        textFont: .system(.headline, design: .rounded)
                                    )
                                }
                                .buttonStyle(.borderedProminent)

                            if let selectedData {
                                Text("Selected file: \(selectedFileName.isEmpty ? "media" : selectedFileName) • \(ByteCountFormatter.string(fromByteCount: Int64(selectedData.count), countStyle: .file))")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            TextField("Optional caption", text: $viewModel.caption, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Toggle("I allow WongSmileClub to repost this", isOn: $viewModel.consentRepost)

                            Text("Do not include medical details; we will call you.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: viewModel.status.isSubmitting ? "Submitting..." : "Submit", systemImage: AppSymbol.submit) {
                        guard let selectedData else { return }
                        Task {
                            await viewModel.submit(fileData: selectedData, fileName: selectedFileName, mimeType: selectedMimeType)
                        }
                    }
                    .disabled(viewModel.status.isSubmitting || viewModel.name.isEmpty || viewModel.contact.isEmpty || selectedData == nil)

                    NavigationLink {
                        ReportConcernView(config: config, formspree: formspree)
                    } label: {
                        AppLabel(
                            title: "Report a concern",
                            systemImage: AppSymbol.report,
                            iconSize: AppIconSize.inline,
                            textFont: .system(.subheadline, design: .rounded)
                        )
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(viewModel.mediaType.title)
        .onAppear {
            guard let profile = profiles.first else { return }
            if viewModel.name.isEmpty { viewModel.name = profile.name }
            if viewModel.contact.isEmpty {
                viewModel.contact = profile.email.isEmpty ? profile.phone : profile.email
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            Task {
                do {
                    if let data = try await newItem.loadTransferable(type: Data.self) {
                        selectedData = data
                        let type = newItem.supportedContentTypes.first
                        let fileExtension = type?.preferredFilenameExtension ?? (viewModel.mediaType == .photo ? "jpg" : "mov")
                        selectedFileName = "\(viewModel.mediaType.rawValue)-\(Int(Date().timeIntervalSince1970)).\(fileExtension)"
                        selectedMimeType = type?.preferredMIMEType ?? (viewModel.mediaType == .photo ? "image/jpeg" : "video/mp4")
                    }
                } catch {
                    viewModel.status = .failure(message: "Unable to load selected file.")
                }
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
                title: "Submitted",
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
