import SwiftUI

struct DateCardView: View {
    let date: RosterDate

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(date.date.relativeString)
                    .font(.mediumFont(.caption))
                    .foregroundStyle(.white.opacity(0.5))
                Spacer()
            }
            Text(date.notes)
                .font(.mediumFont(.subheadline))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)

            HStack {
                DataBadge(string: date.vibe.pillText)

                if let intimacyPillText = date.intimacyLevel.pillText {
                    DataBadge(string: intimacyPillText)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
        }
    }
}

struct DateNavigationLink: View {
    let date: RosterDate
    @State private var isActive = false

    var body: some View {
        Button {
            isActive = true
        } label: {
            DateCardView(date: date)
        }
        .navigationDestination(isPresented: $isActive) {
            DateDetailView(date: date)
        }
    }
}

#Preview {
    let date = RosterDate(id: UUID(),
                          date: Date(),
                          vibe: .amazing,
                          intimacyLevel: .hookup,
                          spentAmount: 50.0,
                          notes: "Went to farmer's market, grabbed lunch, and watched a movie at home.")
    NavigationStack {
        DateNavigationLink(date: date)
    }
}
