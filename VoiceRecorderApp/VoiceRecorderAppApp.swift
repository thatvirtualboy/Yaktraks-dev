//
//  VoiceRecorderAppApp.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/19/21.
//

import SwiftUI
import TelemetryDeck

@main
struct VoiceRecorderAppApp: App {
    
    var body: some Scene {
        
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        WindowGroup {
            MainView()
                .onAppear {
                    UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
                    print("App launch count: ", currentCount)
                    StoreReviewHelper.incrementAppOpenedCount()
                }
        }
    }
    
    // Telemetry Init
    init() {
        
        let configuration = TelemetryManagerConfiguration(
            appID: "EA3E6E6A-C4C9-447B-8F8E-E3EE8C2ACF30")
        //configuration.sendSignalsInDebugConfiguration = true // for testing purposes
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        let proUser = UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro")
        let locale = NSLocale.current.identifier
        TelemetryManager.initialize(with: configuration)
        
        TelemetryManager.send("applicationDidFinishLaunching",
                              with: [
                                "Language": "\(String(describing: locale))",
                                "Launch Count": "\(currentCount)",
                                "Pro User" : "\(proUser)"
                              ])
    }
}
