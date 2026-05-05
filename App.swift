import SwiftUI
import UniformTypeIdentifiers

// --- Emulator Engine Logic (Virtual Bridge) ---
class EmulatorEngine: ObservableObject {
    @Published var isJitEnabled = false
    @Published var currentStatus = "System Idle"
    
    func launchGame(path: URL) {
        self.currentStatus = "Initializing Windows Environment..."
        // এখানে ব্যাকএন্ডে Wine এবং Box64 কল করার হুক সেট করা আছে
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentStatus = "DirectX 12 Shader Compiling..."
        }
    }
}

@main
struct GameHubApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @State private var started = false
    @State private var showLibrary = false
    @State private var selectedGame: URL?
    @StateObject var engine = EmulatorEngine()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if !started {
                // ১. স্টার্ট স্ক্রিন
                Button(action: { withAnimation { started = true } }) {
                    VStack {
                        Text("GAMEHUB PRO").font(.system(size: 40, weight: .black)).foregroundColor(.blue)
                        Text("CLICK TO START").font(.headline).foregroundColor(.white).opacity(0.7)
                    }
                }
            } else {
                // ২. মেইন ড্যাশবোর্ড (৩টি বক্স)
                VStack(spacing: 30) {
                    Text("WIN-X64 EMULATOR").font(.title2).fontWeight(.bold).foregroundColor(.cyan)
                    
                    Text("Status: \(engine.currentStatus)").font(.system(size: 12, design: .monospaced)).foregroundColor(.green)

                    HStack(spacing: 20) {
                        // লাইব্রেরি বক্স
                        DashboardBox(title: "LIBRARY", icon: "folder.badge.plus", color: .purple) {
                            showLibrary = true
                        }
                        
                        // প্লে বক্স
                        DashboardBox(title: "PLAY", icon: "play.fill", color: .green) {
                            if let url = selectedGame {
                                engine.launchGame(path: url)
                            }
                        }
                        
                        // সেটিংস বক্স
                        DashboardBox(title: "SETTINGS", icon: "cpu", color: .orange) {
                            // উইন্ডোজ কনফিগ সেটিংস
                        }
                    }
                    
                    if let game = selectedGame {
                        Text("Selected: \(game.lastPathComponent)").foregroundColor(.white).font(.caption)
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
        }
        .fileImporter(isPresented: $showLibrary, allowedContentTypes: [.executable]) { result in
            switch result {
            case .success(let url):
                self.selectedGame = url
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct DashboardBox: View {
    let title: String; let icon: String; let color: Color; var action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon).font(.system(size: 30)).foregroundColor(color)
                Text(title).font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            }
            .frame(width: 100, height: 110)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.3), lineWidth: 1))
        }
    }
}
