import SwiftUI
import SwiftData

struct CareView: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @Query private var profiles: [UserProfile]

    @State private var activeProfile: UserProfile?
    @State private var loadedProfile = false
    @State private var showSafari = false
    @State private var safariURL: URL?
    @State private var showNotificationAlert = false
    @State private var notificationMessage = ""
    @State private var reminderTime = Date()

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 20) {
                    nextStepCard

                    recallCard

                    portalCard

                    educationCard

                    questionsCard

                    careTeamCard

                    OffersPreviewRow()

                    emergencyCard
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Care")
        .sheet(isPresented: $showSafari) {
            if let safariURL {
                SafariView(url: safariURL)
            }
        }
        .alert("Reminders", isPresented: $showNotificationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(notificationMessage)
        }
        .onAppear {
            if loadedProfile { return }
            loadedProfile = true
            if let profile = profiles.first {
                activeProfile = profile
            } else {
                let newProfile = UserProfile()
                modelContext.insert(newProfile)
                activeProfile = newProfile
                try? modelContext.save()
            }
            syncReminderTime()
        }
        .onChange(of: reminderTime) { _, newValue in
            updateReminderTime(newValue)
        }
    }

    private var nextStepCard: some View {
        let summary = activeProfile?.pendingAppointmentSummary ?? ""
        let requestedAt = activeProfile?.pendingAppointmentRequestedAt

        return GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Next Step", systemImage: AppSymbol.book)

                if summary.isEmpty {
                    Text("No upcoming appointments are on file.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    NavigationLink {
                        AppointmentRequestView(config: config, formspree: formspree)
                    } label: {
                        PrimaryButtonLabel(title: "Book now", systemImage: AppSymbol.book)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Text("Pending appointment request")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(summary)
                        .font(.headline)

                    if let requestedAt {
                        Text("Requested \(DateFormatter.shortDateTime.string(from: requestedAt))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    NavigationLink {
                        BookView()
                    } label: {
                        AppLabel(
                            title: "View booking options",
                            systemImage: AppSymbol.schedule,
                            textFont: .system(.subheadline, design: .rounded)
                        )
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var recallCard: some View {
        let lastCleaning = activeProfile?.lastCleaningDate
        let interval = activeProfile?.recallIntervalMonths ?? 6
        let nextDue = lastCleaning.map { RecallService.nextDueDate(lastCleaningDate: $0, intervalMonths: interval) }
        let dueSoon = nextDue.map { RecallService.isDueSoon(nextDueDate: $0) } ?? false

        return GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Recall Reminder", systemImage: AppSymbol.recall)

                if lastCleaning == nil {
                    Text("Set your last cleaning date to estimate your next visit.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                DatePicker(
                    "Last cleaning date",
                    selection: lastCleaningBinding,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)

                Picker("Recall interval", selection: recallIntervalBinding) {
                    Text("3 months").tag(3)
                    Text("4 months").tag(4)
                    Text("6 months").tag(6)
                    Text("12 months").tag(12)
                }
                .pickerStyle(.segmented)

                if let nextDue {
                    Text("Next recommended visit: \(DateFormatter.appointmentDateFormatter.string(from: nextDue))")
                        .font(.subheadline)
                        .foregroundStyle(dueSoon ? .primary : .secondary)
                }

                if dueSoon {
                    Text("You are due soon. Tap Book to get on the schedule.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                NavigationLink {
                    BookView()
                } label: {
                    PrimaryButtonLabel(title: "Book now", systemImage: AppSymbol.book)
                }
                .buttonStyle(PrimaryButtonStyle())

                Toggle("Enable reminders", isOn: remindersBinding)

                DatePicker("Reminder time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .disabled(!(activeProfile?.recallNotificationsEnabled ?? false))
            }
        }
    }

    private var portalCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Your Records", systemImage: AppSymbol.portal)
                Text("For official visit summaries, report cards, and documents, use the Patient Portal.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let url = config.patientPortalURL {
                    Button {
                        safariURL = url
                        showSafari = true
                    } label: {
                        PrimaryButtonLabel(title: "Open Patient Portal", systemImage: AppSymbol.portal)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Text("Portal link not configured. Call the office.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let url = config.phoneURL {
                        Button {
                            openURL(url)
                        } label: {
                            AppLabel(
                                title: "Call office",
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

    private var educationCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Aftercare & Education", systemImage: AppSymbol.education)
                Text("Browse tips and guidance for everyday dental care.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    EducationHomeView()
                } label: {
                    AppLabel(
                        title: "Open education library",
                        systemImage: AppSymbol.education,
                        textFont: .system(.subheadline, design: .rounded)
                    )
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var questionsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "My Questions", systemImage: AppSymbol.questions)
                Text("Keep a personal list for your next visit. Stored only on this device.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    MyQuestionsView()
                } label: {
                    AppLabel(
                        title: "Review questions",
                        systemImage: AppSymbol.questions,
                        textFont: .system(.subheadline, design: .rounded)
                    )
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var careTeamCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Specialists", systemImage: AppSymbol.specialists)
                Text("Explore trusted specialists and request help coordinating care.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    SpecialistsDirectoryView()
                } label: {
                    AppLabel(
                        title: "Specialists network",
                        systemImage: AppSymbol.specialists,
                        textFont: .system(.subheadline, design: .rounded)
                    )
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var emergencyCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Emergency", systemImage: AppSymbol.emergency)
                Text("If you need urgent dental help, call us or see emergency guidance.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    EmergencyView()
                } label: {
                    PrimaryButtonLabel(title: "Emergency", systemImage: AppSymbol.emergency)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private var lastCleaningBinding: Binding<Date> {
        Binding(
            get: { activeProfile?.lastCleaningDate ?? Date() },
            set: { newValue in
                activeProfile?.lastCleaningDate = newValue
                saveProfile()
                scheduleReminderIfNeeded()
            }
        )
    }

    private var recallIntervalBinding: Binding<Int> {
        Binding(
            get: { activeProfile?.recallIntervalMonths ?? 6 },
            set: { newValue in
                activeProfile?.recallIntervalMonths = newValue
                saveProfile()
                scheduleReminderIfNeeded()
            }
        )
    }

    private var remindersBinding: Binding<Bool> {
        Binding(
            get: { activeProfile?.recallNotificationsEnabled ?? false },
            set: { newValue in
                Task {
                    await handleReminderToggle(newValue)
                }
            }
        )
    }

    private func handleReminderToggle(_ enabled: Bool) async {
        guard let profile = activeProfile else { return }

        if enabled {
            let granted = await RecallService.requestAuthorization()
            if granted {
                profile.recallNotificationsEnabled = true
                saveProfile()
                scheduleReminderIfNeeded()
            } else {
                profile.recallNotificationsEnabled = false
                saveProfile()
                notificationMessage = "Notifications are disabled. Enable them in Settings to receive reminders."
                showNotificationAlert = true
            }
        } else {
            profile.recallNotificationsEnabled = false
            saveProfile()
            await RecallService.cancelReminder()
        }
    }

    private func scheduleReminderIfNeeded() {
        guard let profile = activeProfile,
              profile.recallNotificationsEnabled,
              let lastCleaning = profile.lastCleaningDate
        else {
            return
        }

        let nextDue = RecallService.nextDueDate(lastCleaningDate: lastCleaning, intervalMonths: profile.recallIntervalMonths)
        Task {
            await RecallService.scheduleReminder(
                nextDueDate: nextDue,
                hour: profile.preferredReminderHour,
                minute: profile.preferredReminderMinute
            )
        }
    }

    private func updateReminderTime(_ time: Date) {
        guard let profile = activeProfile else { return }
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        profile.preferredReminderHour = components.hour ?? 9
        profile.preferredReminderMinute = components.minute ?? 0
        saveProfile()
        scheduleReminderIfNeeded()
    }

    private func syncReminderTime() {
        guard let profile = activeProfile else { return }
        var components = DateComponents()
        components.hour = profile.preferredReminderHour
        components.minute = profile.preferredReminderMinute
        reminderTime = Calendar.current.date(from: components) ?? Date()
    }

    private func saveProfile() {
        try? modelContext.save()
    }
}
