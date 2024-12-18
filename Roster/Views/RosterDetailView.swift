import SwiftUI
import MapKit

struct RosterDetailView: View {
    @EnvironmentObject var rosterStore: RosterStore
    let rosterMember: RosterMember

    var body: some View {
        let isRosterMember = rosterMember.memberType == .rosterMember

        List {
            Section {
                VStack(spacing: 20) {
                    Circle().fill(.white.opacity(0.2)).frame(height: UIScreen.main.bounds.width / 3)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)  // Makes row background transparent
                .listRowInsets(EdgeInsets())
            }


            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(rosterMember.name)
                            .font(.logoFont(.title))
                        if rosterMember.memberType == .rosterMember {
                            Image(systemName: "checkmark.seal.fill")  // For roster status
                                .foregroundColor(.blue)
                        }
                    }

                    // Stats
                    HStack {
                        if rosterMember.memberType == .rosterMember,
                            let health = rosterMember.health {
                            HealthIndicator(health: health)
                        }

                        if let age = rosterMember.contact.age {
                            Text("🎂 \(String(age))")
                                .font(.mediumFont(.caption))
                                .foregroundStyle(.white.opacity(0.4))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                                )
                        }

                        Text("📆 \(String(rosterMember.dates.count)) Dates")
                            .font(.mediumFont(.caption))
                            .foregroundStyle(.white.opacity(0.4))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .overlay(
                                Capsule()
                                    .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    HStack(spacing: 10) {
                        if let igHandle = rosterMember.contact.instagramHandle,
                           let igProfileURL = URL(string: "https://instagram.com/\(igHandle)") {
                            Button {
                                UIApplication.shared.open(igProfileURL)
                            } label: {
                                Image("instagram_logo")
                                    .resizable()
                                    .interpolation(.high)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .buttonStyle(.plain)  // Removes default button styling
                            .frame(width: 16, height: 16)
                        }

                        if let snapchatHandle = rosterMember.contact.snapchatHandle,
                           let snapchatURL = URL(string: "https://www.snapchat.com/add/\(snapchatHandle)") {
                            Button {
                                UIApplication.shared.open(snapchatURL)
                            } label: {
                                Image("snapchat_logo")
                                    .resizable()
                                    .interpolation(.high)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .buttonStyle(.plain)  // Removes default button styling
                            .frame(width: 20, height: 20)
                        }
                    }

                    if isRosterMember, let upgradedDate = rosterMember.upgradedDate {
                        Text("On Rotation Since \(upgradedDate.longDateString)")
                            .font(.mediumFont(.caption))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .listRowBackground(Color.clear)  // Makes row background transparent
            .listRowInsets(EdgeInsets())

            if let address = rosterMember.contact.address {
                Section {
                    AddressView(name: rosterMember.name, address: address)
                }
                .listRowBackground(Color.clear)  // Makes row background transparent
                .listRowInsets(EdgeInsets())
            }


            Section {
                HStack {
                    Text(rosterMember.notes)
                        .font(.mediumFont(.subheadline))
                        .foregroundStyle(.white.opacity(0.7))
                }
            } header: {
                VStack {
                    HStack {
                        Text("Notes")
                            .font(.mediumFont(.title2))
                            .foregroundStyle(.white.opacity(0.5))

                        Spacer()

                        Label("edit", systemImage: "square.and.pencil")
                            .labelStyle(.iconOnly)
                            .fontWeight(.semibold)
                    }
                    Spacer().frame(height: 10)
                }
                .textCase(nil)
                .listRowInsets(EdgeInsets())
            }

            Section {
                VStack {
                    Button {

                    } label: {
                        Text("Add Date")
                            .font(.mediumFont(.subheadline))
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(.capsule)
                    }

                    Spacer().frame(height: 20)

                    if rosterMember.dates.isEmpty {
                        Text("No Dates Yet 🥀")
                            .font(.mediumFont(.caption))
                            .foregroundStyle(.white.opacity(0.5))
                    } else {
                        VStack(spacing: 20) {
                            ForEach(rosterMember.dates, id: \.id) { date in
                                VStack(alignment: .leading) {
                                    Text(date.date.relativeString)
                                        .font(.mediumFont(.caption))
                                        .foregroundStyle(.white.opacity(0.5))
                                    Text(date.notes)
                                        .font(.mediumFont(.subheadline))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    HStack {

                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.gray.opacity(0.2))
                                .cornerRadius(10)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                                }
                            }
                        }
                    }

                    Spacer().frame(height: 40)
                }
            } header: {
                VStack {
                    HStack {
                        Text("Recent Dates")
                            .font(.mediumFont(.title2))

                        Spacer()

                        Button("See All") {
                            // Action
                        }
                        .foregroundColor(.white)
                    }
                    .textCase(nil)

                    Spacer().frame(height: 10)
                }
            }
            .listRowBackground(Color.clear)  // Makes row background transparent
            .listRowInsets(EdgeInsets())
        }
        .font(.mediumFont(.subheadline))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Label("More", systemImage: "square.and.pencil")
                    .labelStyle(.iconOnly)
                    .fontWeight(.medium)
            }

            ToolbarItem(placement: .principal) {
                HStack {
                    Text(rosterMember.name)
                        .font(.logoFont(.body))
                    if rosterMember.memberType == .rosterMember {
                        Image(systemName: "checkmark.seal.fill")  // For roster status
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

struct AddressView: View {
    @State private var region: MKCoordinateRegion?
    let name: String
    let address: String
    let height = 150.0  // Slightly shorter for this style

    var body: some View {
        if let region {
            ZStack(alignment: .bottom) {
                Map(position: .constant(.region(region))) {
                    Marker(name, coordinate: region.center)
                        .tint(.red)
                }
                .disabled(true)
                .frame(height: height)
                .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))

                // Address bar at bottom
                Link(destination: URL(string: "maps://?address=\(address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")")!) {
                    Text(address)
                        .font(.mediumFont(.caption))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(bottomLeadingRadius: 12, bottomTrailingRadius: 12))
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
        } else {
            ProgressView()
                .frame(height: height + 40)  // Account for address bar height
                .task {
                    let geocoder = CLGeocoder()
                    if let placemark = try? await geocoder.geocodeAddressString(address).first,
                       let coordinate = placemark.location?.coordinate {
                        region = MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    }
                }
        }
    }
}


#Preview {
    let _ = RosterStore.loadSampleData()
    NavigationStack {
        RosterDetailView(rosterMember: RosterStore.shared.roster[0])
    }
    .environmentObject(RosterStore.shared)
}
