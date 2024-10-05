import Cocoa
import SwiftUI

@main
struct ScreenTimePasscodeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create and configure a modal dialog popup
        let alert = NSAlert()
        alert.messageText = "Code d'accès au Temps d'écran requis"
        alert.informativeText = "Pour continuer à utiliser Temps d'écran et le contrôle parental sur ce Mac, vous devez entrer le code d'accès au Temps d'écran. Si vous êtes un enfant, demandez à vos parents de vous aider dans cette action."
        alert.alertStyle = .warning

        // Add a text field for entering the passcode
        let inputTextField = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = inputTextField

        // Add buttons
        alert.addButton(withTitle: "Continuer")
        alert.addButton(withTitle: "Annuler")

        // Configure modal behavior
        var response: NSApplication.ModalResponse
        repeat {
            response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // "Continuer" was clicked, validate passcode length
                let passcode = inputTextField.stringValue
                if passcode.count >= 4 {
                    // Valid passcode, copy it to the clipboard
                    copyToClipboard(passcode)
                    break
                } else {
                    // Show an error alert if the passcode is less than 4 characters
                    let errorAlert = NSAlert()
                    errorAlert.messageText = "Code d'accès invalide"
                    errorAlert.informativeText = "Veuillez vous assurer que vous avez entré le bon mot de passe."
                    errorAlert.alertStyle = .critical
                    errorAlert.runModal()
                }
            } else {
                // "Annuler" was clicked, log out the user
                logOutCurrentUser()
                break
            }
        } while true
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
