import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CareView()
            }
            .tabItem {
                Label("Care", systemImage: AppSymbol.care)
            }

            NavigationStack {
                BookView()
            }
            .tabItem {
                Label("Book", systemImage: AppSymbol.book)
            }

            NavigationStack {
                ClubView()
            }
            .tabItem {
                Label("Club", systemImage: AppSymbol.club)
            }

            NavigationStack {
                OffersView()
            }
            .tabItem {
                Label("Offers", systemImage: AppSymbol.offers)
            }

            NavigationStack {
                MoreView()
            }
            .tabItem {
                Label("More", systemImage: AppSymbol.more)
            }
        }
    }
}
