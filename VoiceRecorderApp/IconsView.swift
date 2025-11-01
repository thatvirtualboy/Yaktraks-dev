//
//  IconsView.swift
//  YakTrak
//
//  Created by Ryan Klumph on 8/27/21.
//

import SwiftUI
import TelemetryDeck
import AVFAudio

struct IconsView: View {
    
    @State private var BDPlayer: AVAudioPlayer?
    @AppStorage("soundSetting") var soundSetting = true
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text("App Icons")
                        .font(Font.custom("BungeeInline-Regular", size: 45))
                        .foregroundColor(Color("neonpurple"))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Spacer()
                }
                .padding()
                
                Text("Free")
                    .font(Font.custom("BungeeInline-Regular", size: 35))
                    .foregroundColor(Color("neonpink"))
                HStack {
                    Spacer()
                    Button(action: {
                        if soundSetting { PlayButton() }
                        UIApplication.shared.setAlternateIconName("AppIcon_yellowbolt")
                        TelemetryDeck.signal("ChangedIcon",
                                             parameters: ["Icon" : "Default"])
                    }){
                        Image("icon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonyellow"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    }
                    
                    Button(action: {
                        if soundSetting { PlayButton() }
                        UIApplication.shared.setAlternateIconName(nil)
                        TelemetryDeck.signal("ChangedIcon",
                                             parameters: ["Icon" : "2 point Oh v2"])
                    }){
                        Image("alternate_2.0v2")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    }
                    
                    Button(action: {
                        if soundSetting { PlayButton() }
                        UIApplication.shared.setAlternateIconName("AppIcon_yaktraks")
                        TelemetryDeck.signal("ChangedIcon",
                                             parameters: ["Icon" : "Yak Traks"])
                    }){
                        Image("alternate_yaktraks")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonpink"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
                }
                .padding(.bottom, 40)
                
                HStack {
                    if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                        Image(systemName: "lock.open.fill")
                            .font(.title3)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                    }
                    Text("Premium")
                        .font(Font.custom("BungeeInline-Regular", size: 35))
                        .foregroundColor(Color("neonblue"))
                }
                
                // MARK: PREMIUM ROW ONE
                
                // IF UNLOCKED
                if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_pinkstar")
                            TelemetryDeck.signal("ChangedIcon",
                                                 parameters: ["Icon" : "Pink Star"])
                        }){
                            Image("alternate_pinkstar")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neonpink"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_greenstar")
                            TelemetryDeck.signal("ChangedIcon",
                                                 parameters: ["Icon" : "Green Star"])
                        }){
                            Image("alternate_greenstar")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neongreen"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_bluestar")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "Blue Star"])
                        }){
                            Image("alternate_bluestar")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                    }
                    
                        HStack {
                            Spacer()
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_pinklines")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "Pink Waves"])
                        }){
                            Image("alternate_pinklines")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neonpink"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_facecolors")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "Face Icon"])
                        }){
                            Image("alternate_facecolors")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_blueyak")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "Blue Yak"])
                        }){
                            Image("alternate_blueyak")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                    }.padding()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_djcolors")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "DJ Colors"])
                        }){
                            Image("alternate_djcolors")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_greenlines")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "Green Lines"])
                        }){
                            Image("alternate_greenlines")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neongreen"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action: {
                            if soundSetting { PlayButton() }
                            UIApplication.shared.setAlternateIconName("AppIcon_2.0")
                            TelemetryManager.send("ChangedIcon",
                                                  with: ["Icon" : "2 point Oh"])
                        }){
                            Image("alternate_2.0")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                    }
                } else {
                    
                    // IF LOCKED
                    HStack {
                        Spacer()
                        
                        Image("alternate_pinkstar")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonpink"), radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        
                        Image("alternate_greenstar")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neongreen"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        
                        Image("alternate_bluestar")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Image("alternate_pinklines")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonpink"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        
                        Image("alternate_facecolors")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: .white, radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        
                        Image("alternate_blueyak")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }.padding()
                    
                    HStack {
                        Spacer()
                        Image("alternate_djcolors")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        
                        Image("alternate_greenlines")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neongreen"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        
                        Image("alternate_2.0")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: Color("neonblue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
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
    
}

struct IconsView_Previews: PreviewProvider {
    static var previews: some View {
        IconsView()
    }
}
