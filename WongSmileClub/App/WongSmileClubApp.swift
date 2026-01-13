import SwiftUI
import SwiftData

@main
struct WongSmileClubApp: App {
    let modelContainer: ModelContainer
    let config: AppConfig
    let formspreeClient: FormspreeClient
    @StateObject private var dataStore: AppDataStore

    init() {
        let loadedConfig = AppConfig()
        config = loadedConfig
        formspreeClient = FormspreeClient()
        do {
            modelContainer = try ModelContainer(for: UserProfile.self, PointsTransaction.self, PatientQuestion.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        _dataStore = StateObject(wrappedValue: AppDataStore(config: loadedConfig))
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.appConfig, config)
                .environment(\.formspreeClient, formspreeClient)
                .environmentObject(dataStore)
                .tint(Color.accentColor)
        }
        .modelContainer(modelContainer)
    }
}
