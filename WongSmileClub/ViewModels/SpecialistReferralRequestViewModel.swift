import Foundation

@MainActor
final class SpecialistReferralRequestViewModel: ObservableObject {
    enum ReferralReason: String, CaseIterable, Identifiable {
        case schedulingHelp = "Scheduling help"
        case insuranceQuestions = "Insurance or billing questions"
        case transportation = "Transportation or accessibility help"
        case followUp = "General follow-up"
        case other = "Other"

        var id: String { rawValue }
    }

    @Published var patientName = ""
    @Published var patientContact = ""
    @Published var selectedSpecialistId: String = ""
    @Published var reason: ReferralReason = .schedulingHelp
    @Published var preferredTime = "Morning"
    @Published var hasConsent = false
    @Published var note = ""
    @Published var status: SubmissionStatus = .idle

    let specialists: [Specialist]
    let preferredTimes = ["Morning", "Afternoon", "Evening"]

    private let config: AppConfig
    private let formspree: FormspreeClientProtocol

    init(specialists: [Specialist], selectedSpecialist: Specialist?, config: AppConfig, formspree: FormspreeClientProtocol) {
        self.specialists = specialists
        self.config = config
        self.formspree = formspree
        if let selectedSpecialist {
            selectedSpecialistId = selectedSpecialist.id
        } else {
            selectedSpecialistId = specialists.first?.id ?? ""
        }
    }

    private var selectedSpecialist: Specialist? {
        specialists.first { $0.id == selectedSpecialistId }
    }

    func submit() async {
        guard hasConsent else {
            status = .failure(message: "Please confirm consent so we can coordinate the referral.")
            return
        }
        guard let endpoint = config.specialistCoordinationEndpoint else {
            status = .failure(message: "Specialist coordination endpoint is missing. Update Info.plist.")
            return
        }

        status = .submitting

        let specialist = selectedSpecialist
        let payload: [String: Any] = [
            "patientName": patientName,
            "patientContact": patientContact,
            "specialistId": specialist?.id ?? "",
            "specialistName": specialist?.name ?? "",
            "specialistCategory": specialist?.category ?? "",
            "specialistPractice": specialist?.practiceName ?? "",
            "reason": reason.rawValue,
            "preferredTime": preferredTime,
            "consent": hasConsent ? "yes" : "no",
            "note": note,
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitJSON(endpointURL: endpoint, payload: payload)
            status = .success(message: "We will contact you to coordinate the referral.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}
