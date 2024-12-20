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
    let  _ = RosterMemberStore.loadSampleData()
    NavigationStack {
        DateDetailView(date: RosterDate(id: UUID(),
                                        memberId: UUID(),
                                        date: Date(),
                                        vibe: .amazing,
                                        intimacyLevel: .overnight,
                                        notes: "Went to a concert, had late night dinner at home."))
    }
    .environmentObject(RosterMemberStore.shared)
}
