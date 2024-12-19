import SwiftUI
struct DateDetailView: View {
    let date: RosterDate

    var body: some View {
        List {
            Text(date.date.relativeString)

        }
    }
}

#Preview {
    let  _ = RosterStore.loadSampleData()
    NavigationStack {
        DateDetailView(date: RosterDate(id: UUID(), date: Date(), vibe: .amazing, intimacyLevel: .overnight, notes: "Went to a concert, had late night dinner at home."))
    }
    .environmentObject(RosterStore.shared)
}
