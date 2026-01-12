import SwiftUI
import SwiftData

@main
struct WongSmileClubApp: App {
    let modelContainer: ModelContainer
    let config: AppConfig
    let formspreeClient: FormspreeClient
    @StateObject private var dataStore = AppDataStore()

    init() {
        config = AppConfig()
        formspreeClient = FormspreeClient()
        do {
            modelContainer = try ModelContainer(for: UserProfile.self, PointsTransaction.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
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
