import SwiftUI

struct SettingsTabView: View {

    var body: some View {
        NavigationView() {
            SettingsView()
        }
        .tabItem {
            Image(systemName: "gearshape.fill")
            Text("Settings")
        }
    }
}
