import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.preferredControlTintColor = UIColor(Color.accentColor)
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
