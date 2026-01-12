import SwiftUI

struct PointsPill: View {
    let points: Int

    var body: some View {
        Text("\(points) pts")
            .font(.system(.caption, design: .rounded).weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}
