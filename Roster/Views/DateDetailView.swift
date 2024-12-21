import SwiftUI
struct DateDetailView: View {
    let member: RosterMember
    let date: RosterDate

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header section with blue background
                VStack {
                    HStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 70)

                        VStack(alignment: .leading) {
                            Text(member.name)
                                .font(.title)
                            if let age = member.age {
                                Text("\(age)")
                            }
                        }
                        .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()

                    HStack {
                        if let vibe = date.vibe {
                            DataBadge(string: vibe.pillText)
                        }

                        if let intimacyLevel = date.intimacyLevel, let pillText = intimacyLevel.pillText {
                            DataBadge(string: pillText)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)

                // Detail section with red background
                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        Text("Notes")
                            .font(.title)
                        Spacer()
                    }

                    Divider()

                    Text(date.notes)
                        .font(.subheadline)

                    Spacer(minLength: 600)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
            }
        }
        .background(
            VStack(spacing: 0) {
                Color.gray.opacity(0.2)
                    .frame(maxHeight: .infinity) // Changed this to extend infinitely up
                    .ignoresSafeArea(edges: [.top, .horizontal])
                Color.black
            }
        )
        .navigationTitle(date.date.longDateString)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    print("Edit")
                }
                .tint(.white)
            }
        }
    }
}

#Preview {
    let  _ = RosterMemberStore.loadSampleData()
    NavigationStack {
        DateDetailView(member: RosterMemberStore.shared.all[0],
                       date: RosterDate(id: UUID(),
                                        memberId: UUID(),
                                        date: Date(),
                                        vibe: .amazing,
                                        intimacyLevel: .overnight,
                                        notes: "Went to a concert, had late night dinner at home."))
    }
    .environmentObject(RosterMemberStore.shared)
}
