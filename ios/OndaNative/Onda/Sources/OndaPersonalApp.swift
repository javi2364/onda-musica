import SwiftUI
import AVFAudio

@main
struct OndaPersonalApp: App {
    init() {
        // Enables background-capable audio sessions for permitted media sources.
        // It does NOT override YouTube playback policies or guarantee WKWebView
        // will keep playing after locking the iPhone.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch {
            print("Onda audio session configuration: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
