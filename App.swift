import SwiftUI
import UniformTypeIdentifiers

@main
struct GameHubApp: App {
    var body: some Scene {
        WindowGroup {
            MainContainerView()
        }
    }
}

struct MainContainerView: View {
    @State private var appState: AppState = .launch
    @State private var selectedExePath: String = "No Game Selected"
    
    enum AppState { case launch, dashboard }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if appState == .launch {
                // ১ম স্ক্রিন: ব্ল্যাক স্ক্রিন + ক্লিক টু স্টার্ট
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                            appState = .dashboard
                        }
                    }) {
                        Text("CLICK TO START")
                            .font(.system(size: 22, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(5)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 2))
                            .shadow(color: .blue, radius: 20)
                    }
                    Spacer()
                }
            } else {
                // ২য় স্ক্রিন: Play, Library, Settings
                VStack(spacing: 30) {
                    Text("GAMEHUB ENGINE").font(.title2).fontWeight(.black).foregroundColor(.blue)
                    
                    HStack(spacing: 20) {
                        // বক্স ১: লাইব্রেরি (ফাইল সিলেক্ট করার জন্য)
                        NavigationBox(title: "LIBRARY", icon: "folder.fill", color: .purple) {
                            // এখানে ফাইল পিকার ওপেন হবে
                        }
                        
                        // বক্স ২: প্লে (গেম রান করার জন্য)
                        NavigationBox(title: "PLAY", icon: "play.fill", color: .green) {
                            print("Starting Environment for: \(selectedExePath)")
                        }
                        
                        // বক্স ৩: সেটিংস (উইন্ডোজ এনভায়রনমেন্ট)
                        NavigationBox(title: "SETTINGS", icon: "gearshape.fill", color: .orange) {
                            // সেটিংস ওপেন হবে
                        }
                    }
                    .padding()
                    
                    Text("Target: \(selectedExePath)")
                        .font(.caption).foregroundColor(.gray)
                }
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct NavigationBox: View {
    let title: String; let icon: String; let color: Color; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon).font(.largeTitle).foregroundColor(color)
                Text(title).font(.caption).fontWeight(.bold).foregroundColor(.white)
            }
            .frame(width: 100, height: 100)
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.5), lineWidth: 1))
        }
    }
}
