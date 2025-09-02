//
//  MainView.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/22/21.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            ContentView(audioRecorder: AudioRecorder())
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Say")
                }
            RecordingsView(audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
                .tabItem {
                    Image(systemName: "speaker.wave.2")
                    Text("Play")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
