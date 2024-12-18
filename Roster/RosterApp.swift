//
//  RosterApp.swift
//  Roster
//
//  Created by Albert Jo on 12/16/24.
//

import SwiftUI

@main
struct RosterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(RosterStore.shared)
    }
}
