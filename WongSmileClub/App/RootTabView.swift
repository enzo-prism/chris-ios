import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: AppSymbol.home)
            }

            NavigationStack {
                BookView()
            }
            .tabItem {
                Label("Book", systemImage: AppSymbol.book)
            }

            NavigationStack {
                EarnView()
            }
            .tabItem {
                Label("Earn", systemImage: AppSymbol.earn)
            }

            NavigationStack {
                RewardsView()
            }
            .tabItem {
                Label("Rewards", systemImage: AppSymbol.rewards)
            }

            NavigationStack {
                OffersView()
            }
            .tabItem {
                Label("Offers", systemImage: AppSymbol.offers)
            }
        }
    }
}
