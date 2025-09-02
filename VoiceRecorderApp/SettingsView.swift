//
//  SettingsView.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/20/21.
//

import SwiftUI
import StoreKit
import TelemetryDeck
import AVFAudio

struct SettingsView: View {
    
    enum Sheet { case gopro }
    @State var sheet: Sheet? = nil
    @StateObject var storeManager = StoreManager()
    @AppStorage("recordingDuration") var recordingDuration: Int = 0
    @AppStorage("soundSetting") var soundSetting = true
    @State var SwooshPlayer: AVAudioPlayer?
    var durations = ["6 seconds", "10 seconds", "15 seconds", "25 seconds", "60 seconds"]
    
    let productIDs = [
        "com.thatvirtualboy.VoiceRecorderApp.pro"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(Font.custom("BungeeInline-Regular", size: 45))
                        .foregroundColor(Color("neongreen"))
                        .padding()
                    Spacer()
                }
                Section {
                    HStack {
                        Spacer()
                        if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                            Button(action: {
                                if soundSetting { PlaySwoosh() }
                                sheet = .gopro
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.black)
                                    Text("Awesomeness Unlocked").foregroundColor(.black)
                                }
                            }.buttonStyle(GradientButtonStyle()).padding()
                            Spacer()
                        } else {
                            Button(action: {
                                if soundSetting { PlaySwoosh() }
                                sheet = .gopro
                            }) {
                                HStack {
                                    Image(systemName: "lock.open.fill").foregroundColor(.black)
                                    Text("Unlock More Awesome").foregroundColor(.black)
                                }
                                
                            }.buttonStyle(GradientButtonStyle2()).padding()
                            
                            Spacer()
                        }
                    }
                    .onAppear(perform: {
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIDs)
                    })
                }
                
                Section(header: Text("Preferences")) {
                    HStack {
                        Image(systemName: "speaker.wave.1").foregroundColor(Color("neonblue"))
                        Toggle(isOn: $soundSetting) {
                            Text(" App Sounds")
                        }.toggleStyle(SwitchToggleStyle(tint: Color("neonblue")))
                    }
                    NavigationLink(destination: GrownUpSettings()) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(Color("neonblue"))
                            Text(" Grown-ups")
                        }
                    }
                }
                Section(header: Text("Premium Features"), footer: HStack {
                    Spacer()
                    Text("©  " + String(Calendar.current.component(.year, from: Date())) + " rakTech LLC")
                        .padding()
                    Spacer()
                }) {
                    if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                        HStack {
                            Image(systemName: "timer").foregroundColor(Color("neonblue")).font(.title3)
                            Picker(selection: $recordingDuration, label: Text("Recording duration")) {
                                ForEach(0 ..< durations.count) {
                                    Text(self.durations[$0])
                                }
                            }
                            .onChange(of: recordingDuration) { _ in
                                TelemetryManager.send("Changed Recording Duration", with: ["Duration" : "\(recordingDuration)"])
                                
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "lock.fill").foregroundColor(Color.gray).font(.title3)
                            Text(" Recording duration")
                            Spacer()
                            Text("6 seconds")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    
                    HStack {
                        NavigationLink(destination: IconsView()) {
                            Image(systemName: "square.fill.on.square").foregroundColor(Color("neonblue")).font(.title3)
                            Text(" App Icon")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        .preferredColorScheme(.dark)
        .sheet(using: $sheet) { sheet in
            switch sheet {
            case .gopro:
                ProFeaturesView(storeManager: storeManager)
            }
        }
        
        
    }
    
    func PlaySwoosh() {
        if let BDURL = Bundle.main.url(forResource: "swoosh", withExtension: "mp3") {
            do {
                try SwooshPlayer = AVAudioPlayer(contentsOf: BDURL) /// make the audio player
                SwooshPlayer?.volume = 0.1
                SwooshPlayer?.play()
            } catch {
                print("Couldn't play audio. Error: \(error)")
            }
        }
    }
    
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("neonyellow"), Color("neonblue")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}

struct GradientButtonStyle2: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("neonblue"), Color("neonpink")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}
