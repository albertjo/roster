import SwiftUI

struct DatesView: View {
    @EnvironmentObject var rosterStore: RosterMemberStore
    @EnvironmentObject var dateStore: RosterDateStore

    @State private var selectedDateType = RosterDateType.future
    @State private var showingNewDateSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    HStack(spacing: 12) {  // Add explicit spacing between buttons
                        ForEach(RosterDateType.allCases, id: \.self) { dateType in
                            Button {
                                selectedDateType = dateType
                            } label: {
                                HStack(spacing: 4) {
                                    Text(dateType.rawValue)
                                        .foregroundColor(.white)
                                    Text("\(dateStore.dates(for: dateType).count)")
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedDateType == dateType ? .gray.opacity(0.4) : .gray.opacity(0.2))
                                .overlay {
                                    Capsule()
                                        .strokeBorder(.white.opacity(0.6), lineWidth: selectedDateType == dateType ? 1 : 0)
                                }
                                .clipShape(Capsule())
                            }
                            .tint(.white)
                            .buttonStyle(BorderlessButtonStyle())
                        }

                        Spacer()
                    }

                    Spacer().frame(height: 30)

                    VStack(spacing: 10) {
                        ForEach(dateStore.dates(for: selectedDateType), id: \.id) { rosterDate in
                            DateCell(rosterDate: rosterDate)
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $showingNewDateSheet) {
                NewDateSheet()
            }
            .navigationTitle("Dates")
            .toolbar {
                Button {
                    showingNewDateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .tint(.white)
            }
        }
    }
}

struct DateCell: View {
    let rosterDate: RosterDate

    var body: some View {
        VStack(alignment: .leading) {
            // Scheduling information
            HStack {
                Text(rosterDate.date.longDateString)
                    .font(.subheadline)
                Spacer()

                if rosterDate.date.isFutureOrToday {
                    Text("Upcoming")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            HStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(height: 40)

                Text("Firstname Lastname")
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct NewDateSheet: View {
    @EnvironmentObject var rosterStore: RosterMemberStore
    @State private var selectedMemberId: UUID?

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Roster")
                            .frame(maxWidth: .infinity)
                        ForEach(rosterStore.roster, id: \.id) { member in
                            Button {
                                selectedMemberId = member.id
                            } label: {
                                Text(member.name)
                                    .background(selectedMemberId == member.id ? .green : .clear)
                            }
                        }
                        
                        Text("Prospects")
                            .frame(maxWidth: .infinity)
                        
                        ForEach(rosterStore.prospects, id: \.id) { member in
                            Button {
                                selectedMemberId = member.id
                            } label: {
                                Text(member.name)
                                    .background(selectedMemberId == member.id ? .green : .clear)
                            }
                        }
                        
                        Spacer().frame(height: 100)
                    }
                }

                VStack {
                    Spacer()

                    Button {

                    } label: {
                        Text("Next")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedMemberId == nil)
                }
            }
            .padding()
            .navigationTitle("Going With")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            
        }
    }
}

#Preview {
    let _ = RosterMemberStore.loadSampleData()
    let _ = RosterDateStore.loadSampleData()
    DatesView()
        .environmentObject(RosterDateStore.shared)
        .environmentObject(RosterMemberStore.shared)
}
