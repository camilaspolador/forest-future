import SwiftUI

struct ContentView: View {
    @StateObject var soundManager = SoundManager()
    
    var body: some View {
        NavigationView {
          MenuScreenView()
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }.navigationViewStyle(.stack)
            .environmentObject(soundManager)
    }
}
