//
//  Utilities.swift
//  YakTrak
//
//  Created by Ryan Klumph on 9/7/21.
//

import SwiftUI
import UIKit
import MessageUI

// Send Mail Utility for Settings
struct MailView: UIViewControllerRepresentable {
    
    //@State private var proStatus = false
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
            
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
        
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        let systemVersion = UIDevice.current.systemVersion
        let deviceType = deviceModel()
        let proUser = UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro")
        
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["support@raktech.app"])
        vc.setSubject("[Yaktraks] Support")
        
        vc.setMessageBody("<br /><br /><br /><p>Diagnostic Info:<br />----------------<br />App Version: \(appVersion) <br />Device Type: \(deviceType)<br />iOS Version: \(systemVersion) <br />App Launched: \(currentCount) times <br />Pro: \(proUser) <br />----------------</p>", isHTML: true)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

/// Returns a stable device descriptor.
/// On real iOS hardware, this returns the model identifier (e.g., "iPhone15,4").
/// On Mac Catalyst, returns "Mac (Catalyst)".
/// On iOS apps running on Apple Silicon Mac, returns "Mac (Designed for iPad)".
func deviceModel() -> String {
#if targetEnvironment(macCatalyst)
    return "Mac (Catalyst)"
#else
    if #available(iOS 14.0, *) {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            return "Mac (Designed for iPad)"
        }
    }
    var sysinfo = utsname()
    uname(&sysinfo)
    let identifier = withUnsafePointer(to: &sysinfo.machine) { ptr -> String in
        return ptr.withMemoryRebound(to: CChar.self, capacity: 1) { cptr in
            String(cString: cptr)
        }
    }
    return identifier // e.g., "iPhone15,4"
#endif
}
