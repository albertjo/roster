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
                        .font(.mediumFont(.caption))
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
                            RosterDetailView(memberId: rosterMember.id)
                        } label: {
                            RosterCardView(rosterMember: rosterMember)
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Roster")
                        .font(.logoFont(.largeTitle))
                }
            }
        }
    }
}

struct RosterCardView: View {
    let rosterMember: RosterMember

    var body: some View {
        let isProspect = rosterMember.memberType == .prospect

        HStack {
            Circle().fill(.white.opacity(0.1)).frame(height: 60)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(rosterMember.name)
                        .font(.semiboldFont(.body))
                        .foregroundStyle(.white)

                    if rosterMember.memberType == .rosterMember {
                        Image(systemName: "checkmark.seal.fill")  // For roster status
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
                /*
                Text("📆 5")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                */

                Text("7 Days Ago")
                    .font(.mediumFont(.footnote))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()

            if !isProspect, let health = rosterMember.health {
                HealthIndicator(health: health)
            }
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
                        NavigationLink {
                            RosterDetailView(memberId: prospect.id)
                        } label: {
                            RosterCardView(rosterMember: prospect)
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Prospects")
                        .font(.logoFont(.largeTitle))
                }
            }
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

extension Date {
    var longDateString: String {
        self.formatted(.dateTime.month(.abbreviated).day().year())
    }

    var relativeString: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: self, to: now)

        if let daysAgo = components.day {
            if daysAgo == 0 {
                return "Today"
            } else if daysAgo == 1 {
                return "Yesterday"
            } else if daysAgo < 7 {
                return "\(daysAgo) days ago"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy"
                formatter.locale = Locale(identifier: "en_US")
                return formatter.string(from: self).uppercased()
            }
        }

        // Fallback in case of error calculating components
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self).uppercased()
    }
}

#Preview {
    let _ = RosterStore.loadSampleData()
    ContentView()
        .environmentObject(RosterStore.shared)
}
