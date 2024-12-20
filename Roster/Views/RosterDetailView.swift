import SwiftUI
import MapKit

struct RosterDetailView: View {
    @EnvironmentObject var rosterStore: RosterMemberStore
    @EnvironmentObject var rosterDateStore: RosterDateStore
    let memberId: UUID
    
    @State var showingEditSheet = false

    private var member: RosterMember? {
        rosterStore.member(id: memberId)
    }

    var body: some View {
        if let member = member {
            let dates = rosterDateStore.dates(for: memberId)
            List {
                let isRosterMember = member.memberType == .rosterMember

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
                            Text(member.name)
                                .font(.logoFont(.title))
                            if member.memberType == .rosterMember {
                                Image(systemName: "checkmark.seal.fill")  // For roster status
                                    .foregroundColor(.blue)
                            }
                        }

                        // Stats
                        HStack {
                            if member.memberType == .rosterMember {
                                HealthIndicator(health: member.health)
                            } else {
                                ProspectStageIndicator(stage: member.stage)
                            }

                            if let age = member.age {
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

                            Text("📆 \(dates.count))")
                                .font(.mediumFont(.caption))
                                .foregroundStyle(.white.opacity(0.4))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                                )
                        }

                        HStack(spacing: 20) {
                            if let igHandle = member.contact.instagramHandle,
                               let igProfileURL = URL(string: "https://instagram.com/\(igHandle)") {
                                Button {
                                    UIApplication.shared.open(igProfileURL)
                                } label: {
                                    HStack {
                                        Image("instagram_logo")
                                            .resizable()
                                            .interpolation(.high)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16, height: 16)
                                        Text("@\(igHandle)")
                                            .font(.mediumFont(.caption))
                                    }
                                    .foregroundStyle(.white.opacity(0.7))
                                }

                            }

                            if let snapchatHandle = member.contact.snapchatHandle,
                               let snapchatURL = URL(string: "https://www.snapchat.com/add/\(snapchatHandle)") {
                                Button {
                                    UIApplication.shared.open(snapchatURL)
                                } label: {
                                    HStack {
                                        Image("snapchat_logo")
                                            .resizable()
                                            .interpolation(.high)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 18, height: 18)

                                        Text("@\(snapchatHandle)")
                                            .font(.mediumFont(.caption))
                                    }
                                    .foregroundStyle(.white.opacity(0.7))
                                }
                            }

                            if let phoneNumber = member.contact.phoneNumber {
                            }
                        }

                        Group {
                            if isRosterMember, let upgradedDate = member.upgradedDate {
                                Text("On Rotation Since \(upgradedDate.longDateString)")
                            } else {
                                Text("Added On \(member.createdAt.longDateString)")
                            }
                        }
                        .font(.mediumFont(.caption))
                        .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .listRowBackground(Color.clear)  // Makes row background transparent
                .listRowInsets(EdgeInsets())

                if let address = member.contact.address {
                    Section {
                        AddressView(name: member.name, address: address)
                    }
                    .listRowBackground(Color.clear)  // Makes row background transparent
                    .listRowInsets(EdgeInsets())
                }

                Section {
                    HStack {
                        Text(member.notes)
                            .font(.mediumFont(.subheadline))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                } header: {
                    VStack {
                        Spacer().frame(height: 20)

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

                DatesSectionView(memberId: memberId)
            }
            .font(.mediumFont(.subheadline))
            .sheet(isPresented: $showingEditSheet) {
                RosterMemberFormView(mode: MemberFormMode.updating(member))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .labelStyle(.titleOnly)
                            .fontWeight(.medium)
                    }
                    .tint(.white)
                }

                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(member.name)
                            .font(.logoFont(.body))
                        if member.memberType == .rosterMember {
                            Image(systemName: "checkmark.seal.fill")  // For roster status
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
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
   let height = 150.0

   var body: some View {
       Group {
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
                   .frame(height: height + 40)
           }
       }
       .task(id: address) {
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

struct DatesSectionView: View {
    enum DateType: String, CaseIterable {
        case future = "📆 Upcoming"
        case past = "Past"
    }

    @EnvironmentObject var rosterStore: RosterMemberStore
    @EnvironmentObject var rosterDateStore: RosterDateStore
    let memberId: UUID

    @State var selectedDateType = DateType.future

    private var futureDates: [RosterDate] {
        return rosterDateStore.dates(for: memberId).filter({ rosterDate in
            return rosterDate.date.isFutureOrToday
        })
    }

    private var pastDates: [RosterDate] {
        return rosterDateStore.dates(for: memberId).filter({ rosterDate in
            return !rosterDate.date.isFutureOrToday
        })
    }

    var body: some View {
        if let member = rosterStore.member(id: memberId) {
            let dates = rosterDateStore.dates(for: memberId)
            Section {
                VStack {
                    Spacer().frame(height: 20)

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

                    dateTypeToggles

                    Spacer().frame(height: 20)

                    selectedDatesView

                    Spacer().frame(height: 80)
                }
            } header: {
                VStack {
                    Spacer().frame(height: 20)

                    HStack {
                        Text("Dates")
                            .font(.mediumFont(.title2))

                        Spacer()

                        NavigationLink("See All") {
                            DatesView(rosterMember: member)
                        }
                        .tint(.white)
                        .disabled(dates.isEmpty)
                    }
                    .textCase(nil)
                }
            }
            .listRowBackground(Color.clear)  // Makes row background transparent
            .listRowInsets(EdgeInsets())
        }
    }

    private var dateTypeToggles: some View {
        HStack(spacing: 12) {  // Add explicit spacing between buttons
            ForEach(DateType.allCases, id: \.self) { dateType in
                Button {
                    selectedDateType = dateType
                } label: {
                    let dates = dateType == .future ? futureDates : pastDates
                    HStack(spacing: 4) {
                        Text(dateType.rawValue)
                            .foregroundColor(.white)
                        Text("\(dates.count)")
                            .foregroundColor(.white.opacity(0.6))
                    }
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
    }

    private var selectedDatesView: some View {
        Group {
            let dates = selectedDateType == .future ? futureDates : pastDates
            VStack(spacing: 20) {
                ForEach(dates, id: \.id) { date in
                    DateNavigationLink(date: date)
                }
            }
        }

//        if futureDates.isEmpty {
//            Spacer().frame(height: 20)
//            Text("No Scheduled Dates Yet 🥀")
//                .font(.mediumFont(.caption))
//                .foregroundStyle(.white.opacity(0.5))
//        } else {
//            VStack(spacing: 20) {
//                ForEach(futureDates, id: \.id) { date in
//                    DateNavigationLink(date: date)
//                }
//            }
//        }
    }
}

struct DatesView: View {
    @EnvironmentObject var rosterStore: RosterMemberStore
    let rosterMember: RosterMember
    @State var dates: [RosterDate] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(dates, id: \.id) { date in
                    DateNavigationLink(date: date)
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dates")
                    .font(.mediumFont(.body))
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {

                } label: {
                    Label("Add Date", systemImage: "plus")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .tint(.white)
            }
        }
        .task {
            //dates = rosterMember.dates
        }
    }
}

extension Date {
    var isFutureOrToday: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date.now)
        let dateToCompare = calendar.startOfDay(for: self)
        return dateToCompare >= today
    }
}

#Preview {
    let _ = RosterMemberStore.loadSampleData()
    let _ = RosterDateStore.loadSampleData()
    NavigationStack {
        RosterDetailView(memberId: RosterMemberStore.shared.all[0].id)
    }
    .environmentObject(RosterMemberStore.shared)
    .environmentObject(RosterDateStore.shared)
}
