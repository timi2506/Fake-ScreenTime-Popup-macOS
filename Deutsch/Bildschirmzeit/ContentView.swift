import SwiftUI
import AppKit

struct ContentView: View {
    @State private var passcode: String = ""
    @State private var isContinueEnabled: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Um Bildschirmzeit weiterhin auf diesem Mac nutzen zu können musst du den Code für Bildschirmzeit eingeben. Wenn du ein Kind bist, bitte deine Eltern dir hierbei zu helfen")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            
        }
        
    }
}
