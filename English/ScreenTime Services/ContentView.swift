import SwiftUI
import AppKit

struct ContentView: View {
    @State private var passcode: String = ""
    @State private var isContinueEnabled: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("To continue using Screen Time and Parental Control on this Mac you are required to enter the Screen Time Passcode. If you are a child, get your parents to help you with this action.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()

            SecureField("Enter Screen Time Passcode", text: $passcode)
                .onChange(of: passcode) { newValue in
                    isContinueEnabled = !newValue.isEmpty
                }
                .padding()

            HStack {
                Button(action: {
                    logOutCurrentUser()
                }) {
                    Text("Cancel")
                }
                .keyboardShortcut(.cancelAction)
                .padding()

                Button(action: {
                    copyToClipboard(passcode)
                }) {
                    Text("Continue")
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
