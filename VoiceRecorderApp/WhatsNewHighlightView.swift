//
//  WhatsNewHighlightView.swift
//  YakTrak
//
//  Created by Ryan Klumph on 9/1/21.
//

import SwiftUI
import AVFoundation
import TelemetryDeck

struct WhatsNewHighlightView: View {
    
    enum Sheet { case privacySheet }
    @State var sheet: Sheet? = nil
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var micAccess = false
    @State var showConfetti = false
    @State private var ClickPlayer: AVAudioPlayer?
    @State private var SwooshPlayer: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            if showConfetti {
                LottieView(animationName: "confetti", loopMode: .playOnce, contentMode: .scaleAspectFit)
                    .onAppear { PlayUnlocked() }
            }
            VStack {
                Text("Welcome to Yaktraks")
                    .font(.title)
                    .bold()
                    .padding(.top, 50)
                    .padding(.bottom, 40) // place this under header text for prod
                
                HStack {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(Color("neonblue"))
                        .font(.title)
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Turn It Up").bold()
                        Text("Make sure your device is not silenced and the volume is turned up")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 10)
                
                VStack {
                    HStack {
                        Image(systemName: "music.mic")
                            .foregroundColor(Color("neonyellow"))
                            .font(.title)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding()
                        VStack(alignment: .leading) {
                            Text("Enable Microphone").bold()
                            Text("Yaktraks requires access to your device's microphone")
                                .foregroundColor(.secondary)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    Button(action: {
                        
                        let session = AVAudioSession.sharedInstance()
                        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
                            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                                if granted {
                                    print("granted")
                                    micAccess.toggle()
                                    showConfetti.toggle()
                                    TelemetryManager.send("MicAccessGrantedAtLaunch")
                                } else {
                                    print("not granted")
                                    TelemetryManager.send("MicAccess_NOT_GrantedAtLaunch")
                                }
                            })
                        }
                        
                    }, label: {
                        Text(micAccess ? "✓ Access Granted!" : "Enable Mic Access")
                            //.foregroundColor(.black)
                            .bold()
                            .frame(maxWidth: 200)
                    })
                    .buttonStyle(GradientButtonStyle2()).padding()
                    .shadow(color: Color("neonpink").opacity(0.4), radius: 20, x: 0, y: 10)
                }
                
                Spacer()
                
                VStack {
                Image("privacy-handshake-icon")
                    .resizable()
                    .frame(maxWidth: 33, maxHeight: 26)
                    .scaledToFit()
                Text("Yaktraks is built with a privacy-first methodology.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    Text("See how your data is managed...")
                        .foregroundColor(.blue)
                        .font(.footnote)
                        .opacity(0.7)
                        .padding(.bottom, 5)
                    
                }
                .onTapGesture {
                    sheet = .privacySheet
                    TelemetryManager.send("PrivacySheetOpened")
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    PlaySwoosh()
                }, label: {
                    Text("Continue")
                        .foregroundColor(.black)
                        .bold()
                        .frame(maxWidth: 300)
                })
                .buttonStyle(GradientButtonStyle())
                .padding()
                .shadow(color: Color("neongreen").opacity(0.4), radius: 20, x: 0, y: 10)
                .padding(.bottom)
                
            }
            .sheet(using: $sheet) { sheet in
                switch sheet {
                case .privacySheet:
                    PrivacyView()
                    
                }
            }
            
        }.preferredColorScheme(.dark)
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
    
    func PlayUnlocked() {
    if let CompleteSound = Bundle.main.url(forResource: "unlocked", withExtension: "wav") {
                do {
                    try ClickPlayer = AVAudioPlayer(contentsOf: CompleteSound) /// make the audio player
                    ClickPlayer?.volume = 0.8
                    ClickPlayer?.play()
                } catch {
                print("Couldn't play audio. Error: \(error)")
                }
                    }
    }
}

struct WhatsNewHighlightView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewHighlightView()
    }
}
