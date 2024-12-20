import SwiftUI
import Foundation

class RosterMemberStore: ObservableObject {
    @Published var all: [RosterMember] = []

    static let shared = RosterMemberStore()

    var roster: [RosterMember] {
        return all.filter { member in
            member.memberType == .rosterMember
        }
    }

    var prospects: [RosterMember] {
        return all.filter { member in
            member.memberType == .prospect
        }
    }

    func member(id: UUID) -> RosterMember? {
        all.first { $0.id == id } //?? prospects.first { $0.id == id }
    }

    func create(member: RosterMember) {
        all.insert(member, at: 0)
    }

    func update(member: RosterMember) {
        if let index = all.firstIndex(where: { $0.id == member.id }) {
            all[index] = member
        }
    }
}

class RosterDateStore: ObservableObject {
    @Published var all: [RosterDate] = []

    static let shared = RosterDateStore()

    func dates(for memberId: UUID) -> [RosterDate] {
        all.filter { $0.memberId == memberId }
    }

    func date(id: UUID) -> RosterDate? {
        all.first { $0.id == id }
    }

    func create(date: RosterDate) {
        all.insert(date, at: 0)
    }

    func update(date: RosterDate) {
        if let index = all.firstIndex(where: { $0.id == date.id }) {
            all[index] = date
        }
    }

    func delete(date: RosterDate) {
        all.removeAll { $0.id == date.id }
    }
}

struct RosterMember: Identifiable {
    let id: UUID
    var name: String
    var avatarURL: URL?
    var birthday: Date?
    var memberType: MemberType // Roster Member vs. Prospect
    var upgradedDate: Date?
    var lastInteractionDate: Date?
    var source: MemberSource // Bar, Club, Hinge, Etc
    var stage: ProspectStage
    var health: RosterMemberHealth //
    var notes: String
    var contact: Contact
    var labels: Set<String>
    var createdAt: Date
    var updatedAt: Date

    var age: Int? {
        guard let birthday = birthday else { return nil }
        return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year
    }
}

struct RosterDate: Identifiable {
    let id: UUID
    let memberId: UUID
    var date: Date
    var vibe: DateVibe
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
    var createdAt: Date
    var updatedAt: Date
}

// MARK: - Enums
enum MemberType: String, Codable {
    case prospect = "Prospect"
    case rosterMember = "Roster Member"
}

enum MemberSource: String, Codable, CaseIterable {
    // Online Dating
    case hinge
    case tinder
    case bumble
    case grindr
    case feeld
    case raya

    // Social Networks
    case instagram
    case snapchat
    case discord
    case reddit

    // IRL - Social
    case bar
    case club
    case concert
    case festival
    case party
    case wedding

    // IRL - Daily Life
    case work
    case school
    case gym
    case cafe
    case grocery
    case mutualFriends = "mutual friends"

    enum Category: String, CaseIterable {
        case datingApps = "Dating Apps"
        case socialMedia = "Social Media"
        case irlSocial = "IRL Social"
        case irlDaily = "IRL Daily Life"
    }

    var category: Category {
        switch self {
        case .hinge, .tinder, .bumble, .grindr, .feeld, .raya:
            return .datingApps
        case .instagram, .snapchat, .discord, .reddit:
            return .socialMedia
        case .bar, .club, .concert, .festival, .party, .wedding:
            return .irlSocial
        case .work, .school, .gym, .cafe, .grocery, .mutualFriends:
            return .irlDaily
        }
    }

    var emoji: String {
        switch self {
        // Social Networks
        case .instagram: return "📸"
        case .snapchat: return "👻"
        case .discord: return "🎮"
        case .reddit: return "🤖"

        // IRL - Social
        case .bar: return "🍺"
        case .club: return "🪩"
        case .concert: return "🎸"
        case .festival: return "🎪"
        case .party: return "🎉"
        case .wedding: return "💒"

        // IRL - Daily Life
        case .work: return "💼"
        case .school: return "📚"
        case .gym: return "💪"
        case .cafe: return "☕️"
        case .grocery: return "🛒"
        case .mutualFriends: return "👥"

        // Dating Apps - Default emoji
        default: return "❤️"
        }
    }

    static func sources(for category: Category) -> [MemberSource] {
        allCases.filter { $0.category == category }
    }
}

enum ProspectStage: String, Codable, CaseIterable {
    case matched    // Initial match/connection
    case talking    // Actively messaging/texting
    case scheduled  // First date planned
    case met        // Had at least one date
    case cut        // Not moving forward

    var color: Color {
        switch self {
        case .matched:
            return .blue        // #007AFF - Cool, neutral start
        case .talking:
            return .purple      // #AF52DE - Warming up, engagement
        case .scheduled:
            return .orange      // #FF9500 - Excitement, momentum
        case .met:
            return .green       // #34C759 - Progress, positive
        case .cut:
            return .gray        // #8E8E93 - Neutral ending
        }
    }

    var emoji: String {
        switch self {
        case .matched:    return "✨"
        case .talking:    return "💬"
        case .scheduled:  return "🕒"
        case .met:        return "👋"
        case .cut:        return "🗑️"
        }
    }

    var emojiText: String {
        return "\(emoji) \(rawValue.capitalizedFirstLetter)"
    }
}

enum RosterMemberHealth: String, Codable, CaseIterable {
    case active
    case benched // Taking a break
    case retired // Ended but on good terms

    var isActive: Bool {
        return self == .active || self == .benched
    }

    var color: Color {
        switch self {
        case .active:
            return .green
        case .benched:
            return .yellow
        case .retired:
            return .gray
        }
    }

    var icon: String {
        switch self {
        case .active:
            return "circle.fill"
        case .benched:
            return "pause.fill"
        case .retired:
            return "pause.fill"
        }
    }
}

enum DateVibe: String, Codable {
    case amazing
    case good
    case neutral
    case awkward
    case bad

    var pillText: String {
        switch self {
        case .amazing: "Amazing 🥰"
        case .good: "Good ☺️"
        case .neutral: "Okay 😐"
        case .awkward: "Awkward 🥲"
        case .bad: "Bad 🤮"
        }
    }
}

enum IntimacyLevel: String, Codable {
    case none
    case kissing
    case hookup
    case overnight

    var pillText: String? {
        switch self {
        case .none: nil
        case .kissing: "Kissed 💋"
        case .hookup: "Hooked Up 🩵"
        case .overnight: "Stayed Over 🌙"
        }
    }
}

extension RosterMemberStore {
    static func loadSampleData() {
        let store = RosterMemberStore.shared

        // MARK: - Sample Roster Members
        let rosterMembers: [RosterMember] = [
            RosterMember(
                id: UUID(uuidString: "1E2F3D4C-5B6A-7890-1234-567890ABCDEF")!,
                name: "Sarah",
                avatarURL: URL(string: "https://example.com/sarah.jpg"),
                birthday: Calendar.current.date(byAdding: .year, value: -27, to: Date()),
                memberType: .rosterMember,
                upgradedDate: Calendar.current.date(byAdding: .day, value: -45, to: Date()),
                lastInteractionDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
                source: .hinge,
                stage: .met,
                health: .active,
                notes: "Great chemistry, loves indie music, works in tech",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "sarahsmith",
                    snapchatHandle: "ssmith22",
                    tikTokHandle: nil,
                    phoneNumber: "555-0123",
                    address: "50 West 4th Street, New York, NY, 10012",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Foodie", "Tech", "Artsy"],
                createdAt: Date(),
                updatedAt: Date()
            ),
            RosterMember(
                id: UUID(uuidString: "2A3B4C5D-6E7F-8901-2345-678901BCDEF0")!,
                name: "Jessica",
                avatarURL: URL(string: "https://example.com/jessica.jpg"),
                birthday: Calendar.current.date(byAdding: .year, value: -25, to: Date()),
                memberType: .rosterMember,
                upgradedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
                lastInteractionDate: Calendar.current.date(byAdding: .day, value: -27, to: Date()),
                source: .bumble,
                stage: .met,
                health: .benched,
                notes: "Taking it slow, great conversations",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "jessicaj",
                    snapchatHandle: nil,
                    tikTokHandle: "jessj",
                    phoneNumber: "555-0456",
                    address: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Yoga", "Vegan", "Writer"],
                createdAt: Date(),
                updatedAt: Date()
            )
        ]

        // MARK: - Sample Prospects
        let prospects: [RosterMember] = [
            RosterMember(
                id: UUID(uuidString: "3B4C5D6E-7F8A-9012-3456-789012CDEF01")!,
                name: "Emma",
                avatarURL: URL(string: "https://example.com/emma.jpg"),
                birthday: nil,
                memberType: .prospect,
                upgradedDate: nil,
                source: .mutualFriends,
                stage: .talking,
                health: .active,
                notes: "Friend of Alex, seems interesting",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "emmak",
                    snapchatHandle: nil,
                    tikTokHandle: nil,
                    phoneNumber: "555-0789",
                    address: "San Francisco",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Friend of Friend", "Doctor"],
                createdAt: Date(),
                updatedAt: Date()
            ),
            RosterMember(
                id: UUID(uuidString: "4D5E6F7A-8B9C-0123-4567-89012DEFAB12")!,
                name: "Madison",
                avatarURL: URL(string: "https://example.com/madison.jpg"),
                birthday: nil,
                memberType: .prospect,
                upgradedDate: nil,
                source: .hinge,
                stage: .scheduled,
                health: .active,
                notes: "First date planned for next week at wine bar",
                contact: Contact(
                    id: UUID(),
                    instagramHandle: "maddie_r",
                    snapchatHandle: "mads22",
                    tikTokHandle: nil,
                    phoneNumber: nil,
                    address: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Finance", "Gym"],
                createdAt: Date(),
                updatedAt: Date()
            ),
            RosterMember(
                id: UUID(uuidString: "5E6F7A8B-9C0D-1234-5678-90123EFABC23")!,
                name: "Olivia",
                avatarURL: URL(string: "https://example.com/olivia.jpg"),
                birthday: nil,
                memberType: .prospect,
                upgradedDate: nil,
                source: .bar,
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
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Met IRL", "Bartender"],
                createdAt: Date(),
                updatedAt: Date()
            )
        ]

        store.all = rosterMembers + prospects
    }
}

extension RosterDateStore {
    static func loadSampleData() {
        let store = RosterDateStore.shared
        store.all = [
            RosterDate(
                id: UUID(),
                memberId: UUID(uuidString: "1E2F3D4C-5B6A-7890-1234-567890ABCDEF")!,
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                vibe: .amazing,
                intimacyLevel: .overnight,
                spentAmount: 85.0,
                notes: "Dinner at Italian place, then drinks at rooftop bar"
            ),
            RosterDate(
                id: UUID(),
                memberId: UUID(uuidString: "1E2F3D4C-5B6A-7890-1234-567890ABCDEF")!,
                date: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,
                vibe: .good,
                intimacyLevel: .hookup,
                spentAmount: 40.0,
                notes: "Coffee and walk in the park, came over after"
            ),
            RosterDate(
                id: UUID(uuidString: "2A3B4C5D-6E7F-8901-2345-678901BCDEF0")!,
                memberId: UUID(),
                date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
                vibe: .good,
                intimacyLevel: .kissing,
                spentAmount: 60.0,
                notes: "Vegan restaurant and art gallery"
            )
        ]
    }
}
