import SwiftUI

@main
struct ServiceAnnouncementApp: App {
    @StateObject var model: Model = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentListView().environmentObject(model)
        }
    }
}
