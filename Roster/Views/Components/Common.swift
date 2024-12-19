import SwiftUI

struct HealthIndicator: View {
    let health: RosterMemberHealth

    var body: some View {
        HStack(spacing: 4) {  // Adjust this value for desired spacing
            Image(systemName: health.icon)
            Text(health.rawValue)
        }
        .font(.mediumFont(.caption))
        .foregroundStyle(health.color)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(health.color.opacity(0.2))
        .clipShape(.capsule)
    }
}

struct DataBadge: View {
    let string: String
    var body: some View {
        Text(string)
            .font(.mediumFont(.caption))
            .foregroundStyle(.white)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .overlay(
                Capsule()
                    .fill(.white.opacity(0.1))
            )
    }
}
