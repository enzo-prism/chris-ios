import Foundation

@MainActor
final class AppointmentRequestViewModel: ObservableObject {
    enum AppointmentType: String, CaseIterable, Identifiable {
        case cleaning = "Cleaning"
        case invisalignConsult = "Invisalign consult"
        case cosmeticConsult = "Cosmetic consult"
        case emergency = "Emergency"
        case other = "Other"

        var id: String { rawValue }
    }

    @Published var fullName = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var preferredDate = Date()
    @Published var preferredTime = "Morning"
    @Published var appointmentType: AppointmentType = .cleaning
    @Published var notes = ""
    @Published var status: SubmissionStatus = .idle

    let preferredTimes = ["Morning", "Afternoon", "Evening"]

    private let config: AppConfig
    private let formspree: FormspreeClientProtocol

    init(config: AppConfig, formspree: FormspreeClientProtocol) {
        self.config = config
        self.formspree = formspree
    }

    func submit() async {
        guard let endpoint = config.appointmentEndpoint else {
            status = .failure(message: "Appointment endpoint is missing. Update Info.plist.")
            return
        }

        status = .submitting
        let payload: [String: Any] = [
            "fullName": fullName,
            "phone": phone,
            "email": email,
            "preferredDay": DateFormatter.appointmentDateFormatter.string(from: preferredDate),
            "preferredTime": preferredTime,
            "appointmentType": appointmentType.rawValue,
            "notes": notes,
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitJSON(endpointURL: endpoint, payload: payload)
            status = .success(message: "We will reach out shortly.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}

extension DateFormatter {
    static let appointmentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
