import SwiftUI

struct MoreView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree

    var body: some View {
        ZStack {
            AppBackground()

            List {
                Section {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Label("Profile", systemImage: AppSymbol.profile)
                    }

                    NavigationLink {
                        PointsHistoryView()
                    } label: {
                        Label("Points History", systemImage: AppSymbol.history)
                    }
                }

                Section {
                    NavigationLink {
                        PracticeInfoView()
                    } label: {
                        Label("Practice Info", systemImage: AppSymbol.practice)
                    }

                    NavigationLink {
                        SupportView()
                    } label: {
                        Label("Support", systemImage: AppSymbol.support)
                    }

                    NavigationLink {
                        CommunityGuidelinesView()
                    } label: {
                        Label("Community Guidelines", systemImage: AppSymbol.guidelines)
                    }

                    NavigationLink {
                        ReportConcernView(config: config, formspree: formspree)
                    } label: {
                        Label("Report a Concern", systemImage: AppSymbol.report)
                    }

                    NavigationLink {
                        LegalMenuView()
                    } label: {
                        Label("Legal", systemImage: AppSymbol.legal)
                    }

                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: AppSymbol.more)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("More")
    }
}
