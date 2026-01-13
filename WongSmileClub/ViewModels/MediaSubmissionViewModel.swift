import Foundation

enum MediaType: String {
    case photo
    case video

    var title: String {
        switch self {
        case .photo: return "Smile Photo"
        case .video: return "Smile Video"
        }
    }

    var points: Int {
        switch self {
        case .photo: return PointsValues.photo
        case .video: return PointsValues.video
        }
    }

    var source: PointsTransaction.Source {
        switch self {
        case .photo: return .photo
        case .video: return .video
        }
    }
}

@MainActor
final class MediaSubmissionViewModel: ObservableObject {
    @Published var name = ""
    @Published var contact = ""
    @Published var caption = ""
    @Published var consentRepost = false
    @Published var status: SubmissionStatus = .idle

    let mediaType: MediaType
    let maxUploadBytes = 15 * 1024 * 1024

    private let config: AppConfig
    private let formspree: FormspreeClientProtocol
    private let pointsStore: PointsStore

    init(mediaType: MediaType, config: AppConfig, formspree: FormspreeClientProtocol, pointsStore: PointsStore) {
        self.mediaType = mediaType
        self.config = config
        self.formspree = formspree
        self.pointsStore = pointsStore
    }

    func submit(fileData: Data, fileName: String, mimeType: String) async {
        guard let endpoint = config.mediaEndpoint else {
            status = .failure(message: "Media endpoint is missing. Update Info.plist.")
            return
        }
        if fileData.count > maxUploadBytes {
            status = .failure(message: "File is too large. Please choose a smaller file.")
            return
        }

        status = .submitting
        let fields: [String: String] = [
            "name": name,
            "contact": contact,
            "caption": caption,
            "consentRepost": consentRepost ? "yes" : "no",
            "mediaType": mediaType.rawValue,
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitMultipart(endpointURL: endpoint, fields: fields, fileData: fileData, fileName: fileName, mimeType: mimeType)
            pointsStore.addTransaction(
                PointsTransaction(
                    type: .earn,
                    status: .pending,
                    source: mediaType.source,
                    points: mediaType.points,
                    note: mediaType.title
                )
            )
            status = .success(message: "Thanks! We will review it soon.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}
