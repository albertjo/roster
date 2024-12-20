import SwiftUI

struct RosterMemberFormView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var memberFormViewModel: MemberFormViewModel
    @StateObject private var contactsManager = ContactsManager()

    private var title: String {
        if case .creating = memberFormViewModel.mode {
            // This will match any .creating case regardless of the MemberType
            return "New \(memberFormViewModel.memberType.rawValue.capitalizedFirstLetter)"
        } else {
            return "Updating Profile"
        }
    }

    init(mode: MemberFormMode) {
        _memberFormViewModel = StateObject(wrappedValue: MemberFormViewModel(mode: mode))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 20) {
                        Circle().fill(.white.opacity(0.2)).frame(height: UIScreen.main.bounds.width / 3)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowBackground(Color.clear)  // Makes row background transparent
                    .listRowInsets(EdgeInsets())
                }

                Section {
                    LabeledContent("Name") {
                        TextField("Enter Name", text: $memberFormViewModel.name)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.trailing)  // Aligns text to right side
                    }

                    BirthdayDatePicker(birthday: $memberFormViewModel.birthday)

                    MemberSourcePicker(source: $memberFormViewModel.source)

                    if memberFormViewModel.memberType == .prospect {
                        ProspectStagePicker(stage: $memberFormViewModel.prospectStage)
                    } else {
                        RosterMemberHealthPicker(health: $memberFormViewModel.health)
                    }
                }

                if memberFormViewModel.memberType == .prospect, case .updating = memberFormViewModel.mode {
                    Button {
                        memberFormViewModel.upgradeToRoster()
                    } label: {
                        HStack {
                            Text("💖 Upgrade to Roster")
                                .font(.logoFont(.subheadline))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                    }
                    .tint(.black)
                    .listRowBackground(Color.clear)  // Makes row background transparent
                    .listRowInsets(EdgeInsets())

                }

                Section("Contact") {
                    // TODO
                    /*
                    Button("Sync From Contacts") {
                        contactsManager.requestAccess()
                    }
                    */

                    LabeledContent("Phone Number") {
                        TextField("Enter Phone Number", text: memberFormViewModel.phoneBinding)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.trailing)  // Aligns text to right side
                    }

                    LabeledContent("Instagram") {
                        HStack(spacing: 0) {
                            TextField("Enter Instagram", text: memberFormViewModel.instagramBinding)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)  // Aligns text to right side
                        }
                    }

                    LabeledContent("Snapchat") {
                        TextField("Enter Snapchat", text: memberFormViewModel.snapchatBinding)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.trailing)  // Aligns text to right side
                    }


                    TextField("Address", text: memberFormViewModel.addressBinding)
                }

                if case .updating = memberFormViewModel.mode {
                    Button("Delete", role: .destructive) {

                    }
                }
            }
            .font(.mediumFont(.subheadline))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.mediumFont(.subheadline))
                    .foregroundStyle(.white)
                }

                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.mediumFont(.body))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        memberFormViewModel.save()
                        dismiss()
                    }
                    .font(.mediumFont(.subheadline))
                    .tint(.white)
                    .disabled(!memberFormViewModel.validate)
                }
            }
        }
    }
}

private struct BirthdayDatePicker: View {
   @State private var showingSheet = false
   @Binding var birthday: Date?

   var body: some View {
       LabeledContent("Birthday") {
           Button {
               showingSheet = true
           } label: {
               Text(birthday == nil ? "Add Birthday" : birthday!.formatted(date: .abbreviated, time: .omitted))
                   .foregroundStyle(birthday == nil ? .gray.opacity(0.7) : .white)
                   .frame(maxWidth: .infinity, alignment: .trailing)
           }
       }
       .sheet(isPresented: $showingSheet) {
           NavigationStack {
               DatePicker(
                   "Select Date",
                   selection: Binding(
                       get: { birthday ?? Date() },
                       set: { birthday = $0 }
                   ),
                   displayedComponents: [.date]
               )
               .datePickerStyle(.wheel)
               .labelsHidden()
               .padding()
               .navigationTitle("Select Birthday")
               .navigationBarTitleDisplayMode(.inline)
               .toolbar {
                   ToolbarItem(placement: .cancellationAction) {
                       Button("Cancel") {
                           showingSheet = false
                       }
                       .tint(.white)
                   }
                   ToolbarItem(placement: .confirmationAction) {
                       Button("Done") {
                           showingSheet = false
                       }
                       .tint(.white)
                   }
               }
           }
           .presentationDetents([.medium])
       }
   }
}

private struct MemberSourcePicker: View {
    @Binding var source: MemberSource
    @State var showingSheet = false

    var body: some View {
        LabeledContent("Where We Met") {
            Button(emojiText(source)) {
                showingSheet = true
            }
            .tint(.white)
        }
        .sheet(isPresented: $showingSheet) {
            NavigationStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 30) {
                        ForEach(MemberSource.Category.allCases, id: \.self) { category in
                            VStack(alignment: .leading) {
                                Text(category.rawValue)
                                    .foregroundStyle(.white.opacity(0.5))

                                FlowLayout(spacing: 8) {
                                    ForEach(MemberSource.sources(for: category), id: \.self) { memberSource in
                                        Button {
                                            source = memberSource
                                            showingSheet = false
                                        } label: {
                                            Text(emojiText(memberSource))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(source == memberSource ? .white : .gray.opacity(0.1))
                                                .clipShape(Capsule())
                                        }
                                        .tint(source == memberSource ? .black : .white)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Where We Met")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingSheet = false
                        }
                        .tint(.white)
                    }
                }
            }
        }
    }

    private func emojiText(_ memberSource: MemberSource) -> String {
        return "\(memberSource.emoji) \(memberSource.rawValue.capitalizedFirstLetter)"
    }
}

private struct RosterMemberHealthPicker: View {
    @Binding var health: RosterMemberHealth
    @State var showingSheet = false

    var body: some View {
        LabeledContent("Health") {
            Button {
                showingSheet = true
            } label: {
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(health.color)
                        .font(.caption)
                    Text(health.rawValue)
                }
            }
            .tint(.white)
        }
        .sheet(isPresented: $showingSheet) {
            NavigationStack {
                VStack {
                    ForEach(RosterMemberHealth.allCases, id: \.self) { memberHealth in
                        Button {
                            health = memberHealth
                            showingSheet = false
                        } label: {
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(memberHealth.color)
                                    .font(.caption)
                                Text(memberHealth.rawValue)
                                Spacer()
                            }
                            .padding()
                            .background(health == memberHealth ? .white.opacity(0.1) : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))  // Add this line
                        }
                        .tint(.white)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Roster Member Health")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
    }
}

private struct ProspectStagePicker: View {
    @Binding var stage: ProspectStage
    @State var showingSheet = false

    var body: some View {
        LabeledContent("Prospect Stage") {
            Button {
                showingSheet = true
            } label: {
                Text(stage.emojiText)
            }
            .tint(.white)
        }
        .sheet(isPresented: $showingSheet) {
            NavigationStack {
                VStack {
                    ForEach(ProspectStage.allCases, id: \.self) { prospectStage in
                        Button {
                            stage = prospectStage
                            showingSheet = false
                        } label: {
                            HStack {
                                Text(prospectStage.emojiText)
                                Spacer()
                            }
                            .padding()
                            .background(stage == prospectStage ? .white.opacity(0.1) : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))  // Add this line
                        }
                        .tint(.white)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Prospect Stage")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
    }
}

enum MemberFormMode {
    case creating(MemberType)
    case updating(RosterMember)
}

class MemberFormViewModel: ObservableObject {
    private var store: RosterMemberStore { RosterMemberStore.shared }
    let mode: MemberFormMode

    @Published var name: String
    @Published var avatarURL: URL?
    @Published var birthday: Date?
    @Published var memberType: MemberType
    @Published var upgradedDate: Date?
    @Published var lastInteractionDate: Date?
    @Published var source: MemberSource
    @Published var prospectStage: ProspectStage
    @Published var health: RosterMemberHealth
    @Published var notes: String
    @Published var contact: Contact
    @Published var labels: Set<String>
    @Published var createdAt: Date
    @Published var updatedAt: Date

    var addressBinding: Binding<String> {
        Binding(
            get: { self.contact.address ?? "" },
            set: { self.contact.address = $0.isEmpty ? nil : $0 }
        )
    }

    var phoneBinding: Binding<String> {
        Binding(
            get: { self.contact.phoneNumber ?? "" },
            set: { self.contact.phoneNumber = $0.isEmpty ? nil : $0 }
        )
    }

    var instagramBinding: Binding<String> {
        Binding(
            get: { self.contact.instagramHandle ?? "" },
            set: { self.contact.instagramHandle = $0.isEmpty ? nil : $0 }
        )
    }

    var snapchatBinding: Binding<String> {
        Binding(
            get: { self.contact.snapchatHandle ?? "" },
            set: { self.contact.snapchatHandle = $0.isEmpty ? nil : $0 }
        )
    }

    var tiktokBinding: Binding<String> {
        Binding(
            get: { self.contact.tikTokHandle ?? "" },
            set: { self.contact.tikTokHandle = $0.isEmpty ? nil : $0 }
        )
    }

    var lastInteractionDateBinding: Binding<Date?> {
        Binding(
            get: { self.lastInteractionDate },
            set: { self.lastInteractionDate = $0 }
        )
    }

    // URL binding
    var avatarURLBinding: Binding<URL?> {
        Binding(
            get: { self.avatarURL },
            set: { self.avatarURL = $0 }
        )
    }

    var validate: Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }

    init(mode: MemberFormMode) {
        self.mode = mode

        switch mode {
        case .creating(let memberType):
            self.name = ""
            self.memberType = memberType
            self.upgradedDate = memberType == .rosterMember ? Date(): nil
            self.source = .hinge
            self.prospectStage = .matched
            self.health = .active
            self.contact = Contact(id: UUID(), createdAt: Date(), updatedAt: Date())
            self.notes = ""
            self.labels = []
            self.createdAt = Date()
            self.updatedAt = Date()
        case .updating(let rosterMember):
            self.name = rosterMember.name
            self.memberType = rosterMember.memberType
            self.birthday = rosterMember.birthday
            self.source = rosterMember.source
            self.prospectStage = rosterMember.stage
            self.health = rosterMember.health
            self.contact = rosterMember.contact
            self.notes = rosterMember.notes
            self.labels = rosterMember.labels
            self.createdAt = rosterMember.createdAt
            self.updatedAt = rosterMember.updatedAt
        }
    }

    func upgradeToRoster() {
        if case .updating = mode, memberType == .prospect {
            memberType = .rosterMember
            upgradedDate = Date()
        }
    }

    func save() {
        switch mode {
        case .updating(var member):
            member.name = name
            member.memberType = memberType
            member.upgradedDate = upgradedDate
            member.avatarURL = avatarURL
            member.birthday = birthday
            member.source = source
            member.stage = prospectStage
            member.health = health
            member.contact = contact
            member.labels = labels
            member.updatedAt = Date()
            store.update(member: member)
        default:
            let newMember = RosterMember(id: UUID(),
                                         name: name,
                                         memberType: memberType,
                                         upgradedDate: upgradedDate,
                                         source: source,
                                         stage: prospectStage,
                                         health: health,
                                         notes: notes,
                                         contact: contact,
                                         labels: labels,
                                         createdAt: Date(),
                                         updatedAt: Date())
            store.create(member: newMember)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return CGSize(width: result.width, height: result.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, line) in result.lines.enumerated() {
            var x = bounds.minX
            let y = bounds.minY + CGFloat(index) * (result.lineHeight + spacing)

            for item in line {
                let itemSize = subviews[item.index].sizeThatFits(.unspecified)
                subviews[item.index].place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += itemSize.width + spacing
            }
        }
    }

    private struct FlowResult {
        struct Item {
            let index: Int
            let size: CGSize
        }

        var lines: [[Item]] = [[]]
        var lineHeight: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0

            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                lineHeight = max(lineHeight, size.height)

                if x + size.width > maxWidth && !lines[lines.count - 1].isEmpty {
                    lines.append([])
                    x = 0
                }

                lines[lines.count - 1].append(Item(index: index, size: size))
                x += size.width + spacing
                width = max(width, x)
            }

            height = lineHeight * CGFloat(lines.count) + spacing * CGFloat(lines.count - 1)
        }
    }
}

extension String {
    var capitalizedFirstLetter: String {
        guard !self.isEmpty else { return self }
        return self.prefix(1).capitalized + self.dropFirst()
    }
}

#Preview {
    let _ = RosterMemberStore.loadSampleData()
    RosterMemberFormView(mode: .creating(.prospect))
}
