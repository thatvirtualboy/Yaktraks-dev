//
//  GateScreen.swift
//  YakTrak
//
//  Created by Ryan Klumph on 8/30/21.
//

import SwiftUI
import StoreKit
import TelemetryDeck
import AVFAudio

struct GateScreen: View {
    
    enum Sheet { case gopro }
    @State var sheet: Sheet? = nil
    
    @Environment(\.presentationMode) var presentationMode
    @State var tInput1 = "1"
    @State var tInput2 = "2"
    @State var tInput3 = "3"
    @State var input1 = ""
    @State var input2 = ""
    @State var input3 = ""
    @State var nP = ""
    @State var npP = ""
    @State var pressedN  = ""
    @State var randN = 0
    @State var hiddenOpp = 1.0
    @State var showPurchase = false
    @State var showCheck = false
    @State var showError = false
    @State var hideCheck = false
    @StateObject var storeManager = StoreManager()
    @AppStorage("soundSetting") var soundSetting = true
    @State private var ClickPlayer: AVAudioPlayer?
    
    let productIDs = [
        "com.thatvirtualboy.VoiceRecorderApp.pro"
    ]
    
    var body: some View {
        
        ZStack {
            Color(.secondarySystemBackground)
            
            if showCheck {
                VStack {
                    LottieView(animationName: "check",
                               loopMode: .playOnce,
                               contentMode: .scaleAspectFit)
                        .frame(width: 100, height: 100)
                }.onAppear { if soundSetting { PlayUnlocked() } }
                .opacity(hideCheck ? 0 : 1)
            }
            if showError {
                VStack {
                    LottieView(animationName: "error",
                               loopMode: .playOnce,
                               contentMode: .scaleAspectFit)
                        .frame(width: 100, height: 100)
                    
                }.onAppear { if soundSetting { PlayError() } }
            }
            
            /*
             PURCHASE SCREEN
             */
            if showPurchase == true {
                
                ScrollView {
                VStack(alignment: .center) {
                        
                        Capsule()
                            .fill(Color.gray)
                            .frame(width: 80, height: 5)
                            .padding(.vertical)
                        
                        Group {
                            Text("You're about to unlock")
                                .font(Font.custom("BungeeInline-Regular", size: 45))
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            
                            Text ("More FX")
                                .font(Font.custom("BungeeInline-Regular", size: 30))
                                .foregroundColor(Color("neonyellow"))
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            
                            Text ("More Icons")
                                .font(Font.custom("BungeeInline-Regular", size: 30))
                                .foregroundColor(Color("neongreen"))
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Text ("More durations")
                                .font(Font.custom("BungeeInline-Regular", size: 30))
                                .foregroundColor(Color("neonpurple"))
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Text ("Future updates and features")
                                .font(Font.custom("BungeeInline-Regular", size: 30))
                                .foregroundColor(Color("neonpink"))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Text ("No Ads")
                            .font(Font.custom("BungeeInline-Regular", size: 30))
                            .foregroundColor(Color("neonred"))
                            .multilineTextAlignment(.center)
                            .padding()
                        Text ("No Subscriptions")
                            .font(Font.custom("BungeeInline-Regular", size: 30))
                            .foregroundColor(Color("neonred"))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        
                        
                        Spacer()
                        
                        if UserDefaults.standard.bool(forKey: "com.thatvirtualboy.VoiceRecorderApp.pro") {
                            Text("Unlocked!")
                                .gradientForeground(colors: [Color("neonblue"), Color("neonpink")])
                                .padding()
                        } else {
                        Button (action: {
                            storeManager.purchaseProduct(product: storeManager.myProducts.first!)
                            TelemetryManager.send("PremiumButton",
                                                  with: ["Purchased" : "true"])
                        }, label: {
                            Text("Unlock the awesome for $\(storeManager.myProducts.first?.price ?? 1)")
                                //.padding()
                                .cornerRadius(8)
                                .foregroundColor(.black)
                            
                        }).buttonStyle(GradientButtonStyle()).padding()
                        .shadow(color: Color("neongreen").opacity(0.4), radius: 20, x: 0, y: 10)
                        .padding()
                            
                            HStack(spacing: 0) {
                                Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                                Text(" | ")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                Link("Privacy Policy", destination: URL(string: "https://thatvirtualboy.com/privacy")!)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
            
            /*
             LOCK SCREEN
             */
            
            VStack {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 80, height: 5)
                    .padding(.vertical)
                Spacer()
                Text("Grown-ups only! \nPlease enter the numbers shown, in order.")
                    .bold()
                    .padding()
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(width: 400)
                    .gradientForeground(colors: [Color("neonblue"), Color("neonyellow")])
                Spacer()
                HStack {
                    Text(input1)
                        .font(.system(size: 30))
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .gradientForeground(colors: [Color("neonblue"), Color("neonyellow")])

                        .multilineTextAlignment(.center)
                    
                    Text(input2)
                        .font(.system(size: 30))
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .gradientForeground(colors: [Color("neonblue"), Color("neonyellow")])

                        .multilineTextAlignment(.center)
                    
                    Text(input3)
                        .font(.system(size: 30))
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .gradientForeground(colors: [Color("neonblue"), Color("neonyellow")])

                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
                HStack {
                    Group {
                        
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "0"
                            numbersPressed()
                        }) {
                            Text("0")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                            
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "1"
                            numbersPressed()
                        }) {
                            Text("1")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "2"
                            numbersPressed()
                        }) {
                            Text("2")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "3"
                            numbersPressed()
                        }) {
                            Text("3")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "4"
                            numbersPressed()
                        }) {
                            Text("4")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                    }
                }
                HStack {
                    Group {
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "5"
                            numbersPressed()
                        }) {
                            Text("5")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "6"
                            numbersPressed()
                        }) {
                            Text("6")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "7"
                            numbersPressed()
                        }) {
                            Text("7")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "8"
                            numbersPressed()
                        }) {
                            Text("8")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                        Button(action: {
                            if soundSetting { PlayClick() }
                            pressedN = "9"
                            numbersPressed()
                        }) {
                            Text("9")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color("neonblue"))
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("neonblue"), lineWidth: 4)
                                )
                        }
                    }
                }
                Spacer()
            }
            .opacity(hiddenOpp)
        }
        //.opacity(hiddenOpp)
        .onAppear() {
            setNums()
            numberWord()
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            SKPaymentQueue.default().add(storeManager)
            storeManager.getProducts(productIDs: productIDs)
        })
        
    }
    
    func PlayError() {
    if let CompleteSound = Bundle.main.url(forResource: "error", withExtension: "wav") {
                do {
                    try ClickPlayer = AVAudioPlayer(contentsOf: CompleteSound) /// make the audio player
                    ClickPlayer?.volume = 0.8
                    ClickPlayer?.play()
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
    
    func PlayClick() {
    if let CompleteSound = Bundle.main.url(forResource: "click", withExtension: "wav") {
                do {
                    try ClickPlayer = AVAudioPlayer(contentsOf: CompleteSound) /// make the audio player
                    ClickPlayer?.volume = 0.8
                    ClickPlayer?.play()
                } catch {
                print("Couldn't play audio. Error: \(error)")
                }
                    }
    }
    
    func setNums() {
        for _ in 0..<3 {
            randN = Int.random(in: 0..<10)
            npP = npP + "\(randN)"
            print("numbers are \(npP)")
        }
        let char1 = npP[npP.index(npP.startIndex, offsetBy: 0)]
        tInput1 = "\(char1)"
        
        let char2 = npP[npP.index(npP.startIndex, offsetBy: 1)]
        tInput2 = "\(char2)"
        
        let char3 = npP[npP.index(npP.startIndex, offsetBy: 2)]
        tInput3 = "\(char3)"
    }
    
    func numberWord() {
        if tInput1 == "0" {
            input1 = "zero"
        }
        if tInput1 == "1" {
            input1 = "one"
        }
        if tInput1 == "2" {
            input1 = "two"
        }
        if tInput1 == "3" {
            input1 = "three"
        }
        if tInput1 == "4" {
            input1 = "four"
        }
        if tInput1 == "5" {
            input1 = "five"
        }
        if tInput1 == "6" {
            input1 = "six"
        }
        if tInput1 == "7" {
            input1 = "seven"
        }
        if tInput1 == "8" {
            input1 = "eight"
        }
        if tInput1 == "9" {
            input1 = "nine"
        }
        if tInput2 == "0" {
            input2 = "zero"
        }
        if tInput2 == "1" {
            input2 = "one"
        }
        if tInput2 == "2" {
            input2 = "two"
        }
        if tInput2 == "3" {
            input2 = "three"
        }
        if tInput2 == "4" {
            input2 = "four"
        }
        if tInput2 == "5" {
            input2 = "five"
        }
        if tInput2 == "6" {
            input2 = "six"
        }
        if tInput2 == "7" {
            input2 = "seven"
        }
        if tInput2 == "8" {
            input2 = "eight"
        }
        if tInput2 == "9" {
            input2 = "nine"
        }
        if tInput3 == "0" {
            input3 = "zero"
        }
        if tInput3 == "1" {
            input3 = "one"
        }
        if tInput3 == "2" {
            input3 = "two"
        }
        if tInput3 == "3" {
            input3 = "three"
        }
        if tInput3 == "4" {
            input3 = "four"
        }
        if tInput3 == "5" {
            input3 = "five"
        }
        if tInput3 == "6" {
            input3 = "six"
        }
        if tInput3 == "7" {
            input3 = "seven"
        }
        if tInput3 == "8" {
            input3 = "eight"
        }
        if tInput3 == "9" {
            input3 = "nine"
        }
    }
    
    func numbersPressed() {
        if nP == "" {
            nP = pressedN
            print("numbers are \(nP)")
        } else {
            if nP.count == 1 {
                nP = nP + pressedN
                print("numbers are \(nP)")
            } else {
                nP = nP + pressedN
                print("numbers are \(nP)")
                if nP == "\(npP)" {
                    hiddenOpp = 0.0
                    showCheck.toggle()
                    TelemetryManager.send("GrownUpSettings",
                                          with: ["Passed?" : "\(showCheck)"])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        npP = ""
                        nP = ""
                        print("Correct numbers")
                        showPurchase.toggle()
                        hideCheck.toggle()
                    }
                } else {
                    hiddenOpp = 0.0
                    showError.toggle()
                    TelemetryManager.send("GrownUpSettings",
                                          with: ["Passed?" : "\(showCheck)"])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        self.presentationMode.wrappedValue.dismiss()
                        print("Incorrect numbers")
                        npP = ""
                        nP = ""
                        setNums()
                    }
                }
            }
        }
    }
    
    
}


struct GateScreen_Previews: PreviewProvider {
    static var previews: some View {
        GateScreen()
    }
}
