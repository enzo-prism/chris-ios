import SwiftUI

enum AppSymbol {
    static let care = "heart.text.square.fill"
    static let home = "house.fill"
    static let book = "calendar.badge.plus"
    static let earn = "sparkles"
    static let club = "sparkles"
    static let rewards = "gift.fill"
    static let offers = "tag.fill"
    static let more = "ellipsis.circle"
    static let emergency = "cross.case.fill"
    static let call = "phone.fill"
    static let directions = "map.fill"
    static let schedule = "calendar.badge.clock"
    static let recall = "calendar.badge.clock"
    static let reminders = "bell.badge.fill"
    static let profile = "person.crop.circle"
    static let referral = "person.crop.circle.badge.plus"
    static let photo = "camera.fill"
    static let video = "video.fill"
    static let instagram = "at.circle.fill"
    static let copy = "doc.on.doc"
    static let feedback = "bubble.left.and.text.bubble.fill"
    static let review = "star.circle.fill"
    static let shop = "cart.fill"
    static let submit = "paperplane.fill"
    static let confirm = "checkmark"
    static let checklist = "checklist"
    static let success = "checkmark.seal.fill"
    static let selectMedia = "photo.on.rectangle"
    static let warning = "exclamationmark.triangle.fill"
    static let link = "safari.fill"
    static let history = "clock.arrow.circlepath"
    static let practice = "building.2.fill"
    static let legal = "doc.text.fill"
    static let privacy = "lock.shield.fill"
    static let terms = "doc.plaintext"
    static let support = "lifepreserver"
    static let guidelines = "hand.raised.fill"
    static let report = "exclamationmark.bubble.fill"
    static let hours = "clock.fill"
    static let specialists = "stethoscope"
    static let portal = "person.text.rectangle"
    static let education = "book.closed.fill"
    static let questions = "questionmark.bubble.fill"
}

enum AppIconSize {
    static let hero: CGFloat = 48
    static let card: CGFloat = 28
    static let button: CGFloat = 18
    static let inline: CGFloat = 16
    static let nav: CGFloat = 20
}

struct AppIcon: View {
    let name: String
    var size: CGFloat
    var weight: Font.Weight = .semibold
    var color: Color? = nil
    var renderingMode: SymbolRenderingMode = .hierarchical

    var body: some View {
        let image = Image(systemName: name)
            .symbolRenderingMode(renderingMode)
            .font(.system(size: size, weight: weight, design: .rounded))

        Group {
            if let color {
                image.foregroundStyle(color)
            } else {
                image
            }
        }
    }
}

struct AppLabel: View {
    let title: String
    let systemImage: String
    var iconSize: CGFloat = AppIconSize.inline
    var iconWeight: Font.Weight = .semibold
    var textFont: Font = .system(.headline, design: .rounded)
    var spacing: CGFloat = 8
    var iconColor: Color? = nil
    var iconIsDecorative: Bool = true

    var body: some View {
        HStack(spacing: spacing) {
            AppIcon(name: systemImage, size: iconSize, weight: iconWeight, color: iconColor)
                .accessibilityHidden(iconIsDecorative)
            Text(title)
                .font(textFont)
        }
    }
}

struct IconBadge: View {
    let systemImage: String

    var body: some View {
        AppIcon(name: systemImage, size: AppIconSize.inline, weight: .semibold, color: .accentColor)
            .accessibilityHidden(true)
            .padding(8)
            .background(.thinMaterial, in: Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}
