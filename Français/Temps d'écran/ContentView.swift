import SwiftUI
import AppKit

struct ContentView: View {
    @State private var passcode: String = ""
    @State private var isContinueEnabled: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Pour continuer à utiliser Temps d'écran et le contrôle parental sur ce Mac, vous devez entrer le code d'accès au Temps d'écran. Si vous êtes un enfant, demandez à vos parents de vous aider dans cette action.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()

            SecureField("Entrez le code d'accès au Temps d'écran", text: $passcode)
                .onChange(of: passcode) { newValue in
                    isContinueEnabled = !newValue.isEmpty
                }
                .padding()

            HStack {
                Button(action: {
                    logOutCurrentUser()
                }) {
                    Text("Annuler")
                }
                .keyboardShortcut(.cancelAction)
                .padding()

                Button(action: {
                    copyToClipboard(passcode)
                }) {
                    Text("Continuer")
                }
                .disabled(!isContinueEnabled)
                .keyboardShortcut(.defaultAction)
                .padding()
            }
        }
        .padding()
        .frame(width: 400, height: 200)
    }

    private func logOutCurrentUser() {
        let task = Process()
        task.launchPath = "/bin/launchctl"
        task.arguments = ["bootout", "gui/\(getuid())"]
        task.launch()
    }

    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

#Preview {
    ContentView()
}
