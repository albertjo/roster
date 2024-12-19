import SwiftUI

@main
struct RosterApp: App {
    init() {
        let _ = RosterStore.loadSampleData()
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            .font: Font.custom("FKGroteskTrial-Bold", size: 36) //UIFont.systemFont(ofSize: 14, weight: .bold)
//        ]
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        .environmentObject(RosterStore.shared)
    }
}
