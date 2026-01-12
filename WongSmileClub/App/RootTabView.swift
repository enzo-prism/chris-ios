import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                BookView()
            }
            .tabItem {
                Label("Book", systemImage: "calendar.badge.plus")
            }

            NavigationStack {
                EarnView()
            }
            .tabItem {
                Label("Earn", systemImage: "sparkles")
            }

            NavigationStack {
                RewardsView()
            }
            .tabItem {
                Label("Rewards", systemImage: "gift.fill")
            }

            NavigationStack {
                OffersView()
            }
            .tabItem {
                Label("Offers", systemImage: "tag.fill")
            }
        }
    }
}
