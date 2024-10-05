import SwiftUI
import AppKit

struct ContentView: View {
    @State private var passcode: String = ""
    @State private var isContinueEnabled: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Wow easter egg")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            
        }
        
    }
}
