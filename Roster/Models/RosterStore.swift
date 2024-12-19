import SwiftUI
import Foundation

class RosterStore: ObservableObject {
    @Published var roster: [RosterMember] = []
    @Published var prospects: [RosterMember] = []

    static let shared = RosterStore()

    func member(id: UUID) -> RosterMember? {
        roster.first { $0.id == id } ?? prospects.first { $0.id == id }
    }

    func update(member: RosterMember) {
        if member.memberType == .rosterMember {
            if let index = roster.firstIndex(where: { $0.id == member.id }) {
                roster[index] = member
            }
        } else {
            if let index = prospects.firstIndex(where: { $0.id == member.id }) {
                prospects[index] = member
            }
        }
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
    var source: String // Bar, Club, Hinge, Etc
    var stage: ProspectStage?
    var health: RosterMemberHealth? //
    var notes: String
    var contact: Contact
    var labels: Set<String>
    var dates: [RosterDate]
    var createdAt: Date
    var updatedAt: Date

    var age: Int? {
        guard let birthday = birthday else { return nil }
        return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year
    }
}

struct RosterDate: Identifiable {
    let id: UUID
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
    case prospect
    case rosterMember
}

enum ProspectStage: String, Codable {
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
}

enum RosterMemberHealth: String, Codable {
    case active
    case benched // Taking a break
    case archived // Ended but on good terms

    var isActive: Bool {
        return self == .active || self == .benched
    }

    var color: Color {
        switch self {
        case .active:
            return .green
        case .benched:
            return .yellow
        case .archived:
            return .gray
        }
    }

    var icon: String {
        switch self {
        case .active:
            return "circle.fill"
        case .benched:
            return "pause.fill"
        case .archived:
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

extension RosterStore {
    static func loadSampleData() {
        let store = RosterStore.shared

        // MARK: - Sample Roster Members
        let rosterMembers: [RosterMember] = [
            RosterMember(
                id: UUID(),
                name: "Sarah",
                avatarURL: URL(string: "https://example.com/sarah.jpg"),
                birthday: Calendar.current.date(byAdding: .year, value: -27, to: Date()),
                memberType: .rosterMember,
                upgradedDate: Calendar.current.date(byAdding: .day, value: -45, to: Date()),
                lastInteractionDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
                source: "Hinge",
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
                dates: [
                    RosterDate(
                        id: UUID(),
                        date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                        vibe: .amazing,
                        intimacyLevel: .overnight,
                        spentAmount: 85.0,
                        notes: "Dinner at Italian place, then drinks at rooftop bar"
                    ),
                    RosterDate(
                        id: UUID(),
                        date: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,
                        vibe: .good,
                        intimacyLevel: .hookup,
                        spentAmount: 40.0,
                        notes: "Coffee and walk in the park, came over after"
                    )
                ],
                createdAt: Date(),
                updatedAt: Date()
            ),
            RosterMember(
                id: UUID(),
                name: "Jessica",
                avatarURL: URL(string: "https://example.com/jessica.jpg"),
                birthday: Calendar.current.date(byAdding: .year, value: -25, to: Date()),
                memberType: .rosterMember,
                upgradedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
                lastInteractionDate: Calendar.current.date(byAdding: .day, value: -27, to: Date()),
                source: "Bumble",
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
                dates: [
                    RosterDate(
                        id: UUID(),
                        date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
                        vibe: .good,
                        intimacyLevel: .kissing,
                        spentAmount: 60.0,
                        notes: "Vegan restaurant and art gallery"
                    )
                ],
                createdAt: Date(),
                updatedAt: Date()
            )
        ]

        // MARK: - Sample Prospects
        let prospects: [RosterMember] = [
            RosterMember(
                id: UUID(),
                name: "Emma",
                avatarURL: URL(string: "https://example.com/emma.jpg"),
                birthday: nil,
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
                    address: "San Francisco",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Friend of Friend", "Doctor"],
                dates: [],
                createdAt: Date(),
                updatedAt: Date()
            ),
            RosterMember(
                id: UUID(),
                name: "Madison",
                avatarURL: URL(string: "https://example.com/madison.jpg"),
                birthday: nil,
                memberType: .prospect,
                upgradedDate: nil,
                source: "Hinge",
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
                dates: [],
                createdAt: Date(),
                updatedAt: Date()
            ),
            RosterMember(
                id: UUID(),
                name: "Olivia",
                avatarURL: URL(string: "https://example.com/olivia.jpg"),
                birthday: nil,
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
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                labels: ["Met IRL", "Bartender"],
                dates: [],
                createdAt: Date(),
                updatedAt: Date()
            )
        ]

        store.roster = rosterMembers
        store.prospects = prospects
    }
}
