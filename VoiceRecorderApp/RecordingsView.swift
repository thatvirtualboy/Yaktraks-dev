//
//  RecordingsView.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/23/21.
//

import SwiftUI
import StoreKit
import TelemetryDeck
import AVFAudio

struct RecordingsView: View {
    
    enum Sheet { case gopro }
    @State var sheet: Sheet? = nil
    @StateObject var storeManager = StoreManager()
    
    @State private var editMode = EditMode.inactive
    @State private var reverseMode = false
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @AppStorage("isHuman") var isHuman: Bool = true
    @AppStorage("isChipmpunk") var isChipmpunk: Bool = false
    @AppStorage("isMonster") var isMonster: Bool = false
    @AppStorage("isRobot") var isRobot: Bool = false
    @AppStorage("isEcho") var isEcho: Bool = false
    @AppStorage("isClown") var isClown: Bool = false
    @AppStorage("isAlien") var isAlien: Bool = false
    @AppStorage("isRadio") var isRadio: Bool = false
    @AppStorage("playedFirstSound") var playedFirstSound = false
    @AppStorage("soundSetting") var soundSetting = true
    @State private var BDPlayer: AVAudioPlayer?
    
    let productIDs = [
        "com.thatvirtualboy.VoiceRecorderApp.pro"
    ]
    
    var animation: Animation { Animation.easeInOut.repeatForever() }
    
    var body: some View {
        NavigationView {
            ZStack {
                LottieView(animationName: "dots", loopMode: .loop, contentMode: .scaleAspectFill)
                    .ignoresSafeArea()
                if audioRecorder.recordings.isEmpty {
                    VStack {
                        Spacer()
                        Text("No \nYakTraks")
                            .font(Font.custom("BungeeInline-Regular", size: 50))
                            .foregroundColor(Color("neongreen"))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                        Spacer()
                        LottieView(animationName: "astropurple", loopMode: .loop, contentMode: .scaleAspectFit)
                            .frame(width: 300, height: 300)
                        Spacer()
                    }
                } else {
                    VStack {
                        Text("YakTraks")
                            .font(Font.custom("BungeeInline-Regular", size: 50))
                            .foregroundColor(Color("neonblue"))
                            .multilineTextAlignment(.center)
                            .blur(radius: playedFirstSound ? 0 : 5)

                        
                        // MARK: BUTTONS
                        
                        ZStack {
                            HStack {
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = true
                                    isChipmpunk = false
                                    isMonster = false
                                    isRobot = false
                                    isEcho = false
                                    isClown = false
                                    isAlien = false
                                    isRadio = false
                                    print("Human Pressed")
                                    playedFirstSound = true
                                }, label: {
                                    Text("🧒")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neonpurple")))
                                        .clipShape(Circle())
                                        .opacity(!isHuman ? 0.5 : 1)
                                        .saturation(!isHuman ? 0.5 : 1)
                                    
                                })
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = true
                                    isMonster = false
                                    isRobot = false
                                    isEcho = false
                                    isClown = false
                                    isAlien = false
                                    isRadio = false
                                    print("Chipmunk Pressed")
                                }, label: {
                                    Text("🐿")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neongreen")))
                                        .clipShape(Circle())
                                        .opacity(!isChipmpunk ? 0.5 : 1)
                                        .saturation(!isChipmpunk ? 0.5 : 1)
                                })
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = false
                                    isMonster = true
                                    isRobot = false
                                    isEcho = false
                                    isClown = false
                                    isAlien = false
                                    isRadio = false
                                    print("Monster Pressed")
                                }, label: {
                                    Text("😈")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neonyellow")))
                                        .clipShape(Circle())
                                        .opacity(!isMonster ? 0.5 : 1)
                                        .saturation(!isMonster ? 0.5 : 1)
                                })
                                Spacer()
                                
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = false
                                    isMonster = false
                                    isRobot = false
                                    isEcho = false
                                    isClown = false
                                    isAlien = true
                                    isRadio = false
                                    print("Alien Pressed")
                                }, label: {
                                    Text("👽")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neonpink")))
                                        .clipShape(Circle())
                                        .opacity(!isAlien ? 0.5 : 1)
                                        .saturation(!isAlien ? 0.5 : 1)
                                })
                                
                                Spacer()
                            }
                            .opacity(playedFirstSound ? 1 : 0)
                            .disabled(playedFirstSound ? false : true)
                            if playedFirstSound == false {
                                LottieView(animationName: "arrowyellow", loopMode: .loop, contentMode: .scaleAspectFit)
                                    .frame(width: 200, height: 200)
                            }
                        }
                        .padding(.horizontal)
                        
                        if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                            HStack {
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = false
                                    isMonster = false
                                    isRobot = true
                                    isEcho = false
                                    isClown = false
                                    isAlien = false
                                    isRadio = false
                                    print("Robot Pressed")
                                }, label: {
                                    Text("🤖")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neonpink")))
                                        .clipShape(Circle())
                                        .opacity(!isRobot ? 0.5 : 1)
                                        .saturation(!isRobot ? 0.5 : 1)
                                    
                                })
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = false
                                    isMonster = false
                                    isRobot = false
                                    isEcho = true
                                    isClown = false
                                    isAlien = false
                                    isRadio = false
                                    print("Echo Pressed")
                                }, label: {
                                    Text("⛪️")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neonblue")))
                                        .clipShape(Circle())
                                        .opacity(!isEcho ? 0.5 : 1)
                                        .saturation(!isEcho ? 0.5 : 1)
                                })
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = false
                                    isMonster = false
                                    isRobot = false
                                    isEcho = false
                                    isClown = true
                                    isAlien = false
                                    isRadio = false
                                    print("Clown Pressed")
                                }, label: {
                                    Text("🔊")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neonpurple")))
                                        .clipShape(Circle())
                                        .opacity(!isClown ? 0.5 : 1)
                                        .saturation(!isClown ? 0.5 : 1)
                                })
                                Spacer()
                                Button (action: {
                                    if soundSetting { PlayButton() }
                                    isHuman = false
                                    isChipmpunk = false
                                    isMonster = false
                                    isRobot = false
                                    isEcho = false
                                    isClown = false
                                    isAlien = false
                                    isRadio = true
                                    print("Radio Pressed")
                                }, label: {
                                    Text("📻")
                                        .shadow(radius: 10)
                                        .padding()
                                        .font(.system(size: 40))
                                        .background(Color(("neongreen")))
                                        .clipShape(Circle())
                                        .opacity(!isRadio ? 0.5 : 1)
                                        .saturation(!isRadio ? 0.5 : 1)
                                })
                                Spacer()
                            }
                            .opacity(playedFirstSound ? 1 : 0)
                            .disabled(playedFirstSound ? false : true)
                            .padding()
                        } else {
                            // Blank for no purchse
                        }
                        
                        
                        
                        // MARK: RECORDINGS LIST
                        
                        ZStack {
                            RecordingsListView(audioRecorder: audioRecorder)
                                //.preferredColorScheme(.dark)
                                .navigationBarItems(trailing: EditButton())
                                .environment(\.editMode, $editMode)
                            
                            
                            
                        }
                        
                        Spacer()
                        HStack {
                            Spacer()
                            if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                                
                            } else {
                                Button (action: {
                                    if soundSetting { PlayButton2() }
                                    sheet = .gopro
                                    TelemetryManager.send("ProFeaturesView",
                                                          with: ["Opened" : "true"])
                                    
                                }, label: {
                                    Text("Unlock more effects")
                                        .gradientForeground(colors: [Color("neonblue"), Color("neonyellow")])
                                        .font(.body)
                                        .padding()
                                })
                            }
                        }
                    }
                    .sheet(using: $sheet) { sheet in
                        switch sheet {
                        case .gopro:
                            ProFeaturesView(storeManager: storeManager)
                                .onAppear(perform: {
                                    SKPaymentQueue.default().add(storeManager)
                                    storeManager.getProducts(productIDs: productIDs)
                                })
                        }
                    }
                }
            }
            //.ignoresSafeArea()
            //.offset(y: -40)
            //.frame(maxHeight: .infinity)
            .onAppear(perform: {
                self.audioRecorder.fetchRecordings()
                isHuman = true
                isChipmpunk = false
                isMonster = false
                isRobot = false
                isEcho = false
                isClown = false
                isAlien = false
                isRadio = false
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        

        
    }
    func PlayButton() {
    if let BDURL = Bundle.main.url(forResource: "button4", withExtension: "mp3") {
                do {
                    try BDPlayer = AVAudioPlayer(contentsOf: BDURL) /// make the audio player
                    BDPlayer?.volume = 0.1
                    BDPlayer?.play()
                } catch {
                print("Couldn't play audio. Error: \(error)")
                }
                    }
    }
    func PlayButton2() {
    if let BDURL = Bundle.main.url(forResource: "swoosh", withExtension: "mp3") {
                do {
                    try BDPlayer = AVAudioPlayer(contentsOf: BDURL) /// make the audio player
                    BDPlayer?.volume = 0.1
                    BDPlayer?.play()
                } catch {
                print("Couldn't play audio. Error: \(error)")
                }
                    }
    }
}

struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsView(audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}


