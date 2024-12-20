import SwiftUI

@main
struct RosterApp: App {
    init() {
        RosterMemberStore.loadSampleData()
        RosterDateStore.loadSampleData()
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            .font: Font.custom("FKGroteskTrial-Bold", size: 36) //UIFont.systemFont(ofSize: 14, weight: .bold)
//        ]
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        .environmentObject(RosterMemberStore.shared)
        .environmentObject(RosterDateStore.shared)
    }
}
