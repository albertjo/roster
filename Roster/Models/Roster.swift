import Foundation

class RosterStore: ObservableObject {
    @Published var roster: [RosterMember] = []
    @Published var prospects: [RosterMember] = []

    static let shared = RosterStore()
}

struct RosterMember: Identifiable {
    let id: UUID
    var name: String
    var avatarURL: URL?
    var memberType: MemberType // Roster Member vs. Prospect
    var upgradedDate: Date?
    var lastInteractionDate: Date?
    var source: String // Bar, Club, Hinge, Etc
    var stage: ProspectStage?
    var health: RosterMemberHealth? //
    var notes: String
    var contact: Contact
    var labels: Set<String>
    var dates: [RosterDate]
}

struct RosterDate: Identifiable {
    let id: UUID
    var date: Date
    var vibe: String
    var intimacyLevel: IntimacyLevel
    var spentAmount: Double?
    var notes: String
}

struct Contact: Identifiable {
    let id: UUID
    var instagramHandle: String?
    var snapchatHandle: String?
    var tikTokHandle: String?
    var phoneNumber: String?
    var address: String?
    var birthday: Date?
    var createdAt: Date
    var updatedAt: String

    var age: Int? {
        guard let birthday = birthday else { return nil }
        return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year
    }
}

// MARK: - Enums
enum MemberType: String, Codable {
    case prospect
    case rosterMember
}

enum ProspectStage: String, Codable {
    case matched
    case talking
    case plannedDate
    case firstDate
    case hookedUp
    case vibing
    case cut
}

enum RosterMemberHealth: String, Codable {
    case active
    case benched // Taking a break
    case archived // Ended but on good terms
    case blocked // Bad ending

    var isActive: Bool {
        return self == .active || self == .benched
    }
}

enum DateVibe: String, Codable {
    case amazing
    case good
    case neutral
    case awkward
    case bad
}

enum IntimacyLevel: String, Codable {
    case none
    case kissing
    case hookup
    case overnight
}

extension RosterStore {
    static func loadSampleData() {
        let store = RosterStore.shared

        // MARK: - Sample Roster Members
        let rosterMembers: [RosterMember] = [
            RosterMember(
                id: UUID(),
                name: "Sarah",
                avatarURL: URL(string: "https://example.com/sarah.jpg"),
                memberType: .rosterMember,
                upgradedDate: Calendar.current.date(byAdding: .day, value: -45, to: Date()),
                lastInteractionDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
                source: "Hinge",
                stage: .vibing,
                health: .active,
                notes: "Great chemistry, loves indie music, works in tech",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "sarahsmith",
                    snapchatHandle: "ssmith22",
                    tikTokHandle: nil,
                    phoneNumber: "555-0123",
                    address: nil,
                    birthday: Calendar.current.date(byAdding: .year, value: -27, to: Date()),
                    createdAt: Date(),
                    updatedAt: "2024-03-15"
                ),
                labels: ["Foodie", "Tech", "Artsy"],
                dates: [
                    RosterDate(
                        id: UUID(),
                        date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                        vibe: "amazing",
                        intimacyLevel: .overnight,
                        spentAmount: 85.0,
                        notes: "Dinner at Italian place, then drinks at rooftop bar"
                    ),
                    RosterDate(
                        id: UUID(),
                        date: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,
                        vibe: "good",
                        intimacyLevel: .hookup,
                        spentAmount: 40.0,
                        notes: "Coffee and walk in the park, came over after"
                    )
                ]
            ),
            RosterMember(
                id: UUID(),
                name: "Jessica",
                avatarURL: URL(string: "https://example.com/jessica.jpg"),
                memberType: .rosterMember,
                upgradedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
                lastInteractionDate: Calendar.current.date(byAdding: .day, value: -27, to: Date()),
                source: "Bumble",
                stage: .vibing,
                health: .benched,
                notes: "Taking it slow, great conversations",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "jessicaj",
                    snapchatHandle: nil,
                    tikTokHandle: "jessj",
                    phoneNumber: "555-0456",
                    address: nil,
                    birthday: Calendar.current.date(byAdding: .year, value: -25, to: Date()),
                    createdAt: Date(),
                    updatedAt: "2024-03-10"
                ),
                labels: ["Yoga", "Vegan", "Writer"],
                dates: [
                    RosterDate(
                        id: UUID(),
                        date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
                        vibe: "good",
                        intimacyLevel: .kissing,
                        spentAmount: 60.0,
                        notes: "Vegan restaurant and art gallery"
                    )
                ]
            )
        ]

        // MARK: - Sample Prospects
        let prospects: [RosterMember] = [
            RosterMember(
                id: UUID(),
                name: "Emma",
                avatarURL: URL(string: "https://example.com/emma.jpg"),
                memberType: .prospect,
                upgradedDate: nil,
                source: "Friend Introduction",
                stage: .talking,
                health: .active,
                notes: "Friend of Alex, seems interesting",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "emmak",
                    snapchatHandle: nil,
                    tikTokHandle: nil,
                    phoneNumber: "555-0789",
                    address: nil,
                    birthday: nil,
                    createdAt: Date(),
                    updatedAt: "2024-03-17"
                ),
                labels: ["Friend of Friend", "Doctor"],
                dates: []
            ),
            RosterMember(
                id: UUID(),
                name: "Madison",
                avatarURL: URL(string: "https://example.com/madison.jpg"),
                memberType: .prospect,
                upgradedDate: nil,
                source: "Hinge",
                stage: .plannedDate,
                health: .active,
                notes: "First date planned for next week at wine bar",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "maddie_r",
                    snapchatHandle: "mads22",
                    tikTokHandle: nil,
                    phoneNumber: nil,
                    address: nil,
                    birthday: nil,
                    createdAt: Date(),
                    updatedAt: "2024-03-16"
                ),
                labels: ["Finance", "Gym"],
                dates: []
            ),
            RosterMember(
                id: UUID(),
                name: "Olivia",
                avatarURL: URL(string: "https://example.com/olivia.jpg"),
                memberType: .prospect,
                upgradedDate: nil,
                source: "Bar",
                stage: .matched,
                health: .active,
                notes: "Met at Warehouse, good initial conversation",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "liv.smith",
                    snapchatHandle: nil,
                    tikTokHandle: nil,
                    phoneNumber: nil,
                    address: nil,
                    birthday: nil,
                    createdAt: Date(),
                    updatedAt: "2024-03-18"
                ),
                labels: ["Met IRL", "Bartender"],
                dates: []
            )
        ]

        store.roster = rosterMembers
        store.prospects = prospects
    }
}
