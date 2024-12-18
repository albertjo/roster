import SwiftUI

struct ContentView: View {
    @State var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab, content: {
            RosterView()
                .tabItem {
                    Label("Roster", systemImage: "person.3.sequence")
                }
                .tag(0)

            ProspectView()
                .tabItem {
                    Label("Prospects", systemImage: "sparkle")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Dates", systemImage: "calendar")
                }
                .tag(2)
        })
    }
}

struct RosterView: View {
    @EnvironmentObject var rosterStore: RosterStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(rosterStore.roster) { rosterMember in
                        NavigationLink {
                            RosterDetailView(rosterMember: rosterMember)
                        } label: {
                            RosterCardView(rosterMember: rosterMember)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Roster")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") { }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct RosterCardView: View {
    let rosterMember: RosterMember

    var body: some View {
        //let isProspect = rosterMember.memberType == .prospect

        HStack {
            Circle().frame(height: 60)

            VStack(alignment: .leading, spacing: 5) {
                Text(rosterMember.name)
                    .fontWeight(.semibold)
                /*
                Text("📆 5")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                */

                Text("Last Interacted 7 Days Ago")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()

            Group {
                if let health = rosterMember.health {
                    Text(health.rawValue)
                } else if let stage = rosterMember.stage {
                    Text(stage.rawValue)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.green)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.green.opacity(0.1))
            .clipShape(.capsule)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ProspectView: View {
    @EnvironmentObject var rosterStore: RosterStore

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(rosterStore.prospects) { prospect in
                        RosterCardView(rosterMember: prospect)
                    }
                }
            }
            .padding()
            .navigationTitle("Prospects")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var rosterStore: RosterStore

    var body: some View {
        NavigationStack {
            ScrollView {

            }
            .navigationTitle("Settings")
        }
    }
}

struct RosterDetailView: View {
    @EnvironmentObject var rosterStore: RosterStore
    let rosterMember: RosterMember

    var body: some View {
        List {
            Section {
                Circle().fill(.white.opacity(0.2)).frame(height: UIScreen.main.bounds.width / 2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)  // Makes row background transparent
                    .listRowInsets(EdgeInsets())
            }


            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(rosterMember.name)
                        .fontWeight(.semibold)
                        .font(.title)

                    Text("Gym")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.blue.opacity(0.1))
                        .clipShape(.capsule)
                }
            }

            Section {
                NavigationLink {
                    Text("Navigated")
                } label: {
                    HStack {
                        Text("Instagram")
                        Spacer()
                        if let instagramHandle = rosterMember.contact.instagramHandle {
                            Text("@\(instagramHandle)")
                        } else {
                            Text("Add")
                        }
                    }
                }

                NavigationLink {
                    Text("Navigated")
                } label: {
                    HStack {
                        Text("Snapchat")
                        Spacer()
                        if let snapchatHandle = rosterMember.contact.snapchatHandle {
                            Text("@\(snapchatHandle)")
                        } else {
                            Text("Add")
                        }
                    }
                }
            } header: {

            }

            Section {
                VStack {
                    Button("Add Date") {

                    }
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)

                    Spacer().frame(height: 20)

                    Text("No Dates Yet 🥀")
                        .foregroundStyle(.white.opacity(0.5))
                }
            } header: {
                VStack {
                    HStack {
                        Text("Dates")
                            .font(.title2)

                        Spacer()

                        Button("See All") {
                            // Action
                        }
                        .foregroundColor(.blue)
                    }
                    .textCase(nil)

                    Spacer().frame(height: 10)
                }
            }
            .listRowBackground(Color.clear)  // Makes row background transparent
            .listRowInsets(EdgeInsets())

        }
        .navigationTitle(rosterMember.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Label("More", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
            }
        }
    }
}

#Preview {
    let _ = RosterStore.loadSampleData()
    ContentView()
        .environmentObject(RosterStore.shared)
}
