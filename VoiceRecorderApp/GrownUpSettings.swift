//
//  GrownUpSettings.swift
//  YakTrak
//
//  Created by Ryan Klumph on 9/7/21.
//

import SwiftUI
import WKView
import MessageUI
import TelemetryDeck
import AVFAudio

struct GrownUpSettings: View {
    
    enum Sheet { case sendemail, privacy }
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
    @State var showSettings = false
    @State var showCheck = false
    @State var showError = false
    @State var hideCheck = false
    @State var alertNoMail = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @AppStorage("soundSetting") var soundSetting = true
    @State private var ClickPlayer: AVAudioPlayer?
    
    var body: some View {

        ZStack {
            
            if showCheck {
                VStack {
                    LottieView(animationName: "check",
                               loopMode: .playOnce,
                               contentMode: .scaleAspectFit)
                        .frame(width: 100, height: 100)
                }
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
            if showSettings == true {
                Form {
                    HStack {
                        Spacer()
                        Text("Grown-ups")
                            .font(Font.custom("BungeeInline-Regular", size: 40))
                            .foregroundColor(Color("neonpurple"))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                        Spacer()
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "info.circle.fill").foregroundColor(Color("neongreen"))
                            NavigationLink(" About", destination: About())
                        }
                    }
                    
                    Section {
                        Button(action: { sheet = .privacy; TelemetryManager.send("PrivacySheetOpened") }) {
                        HStack {
                            Image(systemName: "lock.shield.fill").foregroundColor(Color("neonyellow"))
                            Text(" Privacy Policy").foregroundColor(.primary)
                        }
                        }
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "envelope.fill").foregroundColor(Color("neonblue"))
                            Button(action: {
                                TelemetryManager.send("Help&SupportPressed")

                                // Prefer in-app composer when available (uses any configured account)
                                if MFMailComposeViewController.canSendMail() {
                                    sheet = .sendemail
                                    return
                                }

                                // Fallback: open user's default mail app via mailto: URL
                                if let url = makeMailtoURL(
                                    to: "support@raktech.app",
                                    subject: "YakTrak Support",
                                    body: defaultSupportEmailBody()
                                ), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    return
                                }

                                // Last resort: show alert (no email app available)
                                TelemetryManager.send("IssueWithMailSetup")
                                print("No email app available")
                                alertNoMail.toggle()
                            }) {
                                Text(" Help & Support").foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        .alert(isPresented: self.$alertNoMail) {
                            Alert(
                                title: Text("No Email App Found"),
                                message: Text("We couldn’t find an email app on this device. You can reach us at support@raktech.app"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(Color("neonpink")).font(.title3)
                            Link(" Leave a review", destination: URL(string: "https://apps.apple.com/us/app/id1583086555?mt=8&action=write-review")!)
                                .foregroundColor(.primary)
                        }
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill").foregroundColor(Color("neonpink"))
                                .font(.title3)
                            Button(action: {
                                actionSheet();
                                TelemetryManager.send("ShareButtonPressed")
                                
                            }) {
                                Text(" Share the fun")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    Section(header: Text(""), footer: HStack {
                        Spacer()
                        Text("©  " + String(Calendar.current.component(.year, from: Date())) + " rakTech LLC")
                            .padding()
                        Spacer()
                    }) {
                        HStack {
                            Image("twitter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            Link(" Twitter", destination: URL(string: "https://x.com/thatvirtualboy")!)
                                .foregroundColor(.primary)
                        }
                    }
                }

            }
            
            /*
             LOCK SCREEN
             */
            
            VStack {
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
        .sheet(using: $sheet) { sheet in
            switch sheet {
            case .sendemail:
                MailView(result: self.$result)
                    .accentColor(.blue)
                    .preferredColorScheme(.dark)
            case .privacy:
                PrivacyView()
            }
        }
        .onAppear() {
            setNums()
            numberWord()
        }
        .preferredColorScheme(.dark)
        
    }
    
    // Build a properly percent-encoded mailto: URL
    func makeMailtoURL(to: String, subject: String, body: String) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = to
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]
        return components.url
    }

    // Provide a helpful default email body with basic diagnostics
    func defaultSupportEmailBody() -> String {
        let app = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "YakTrak"
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let systemVersion = UIDevice.current.systemVersion
        let device = UIDevice.current.model
        return "\n\n—\nApp: \(app) \(version) (\(build))\nDevice: \(device)\niOS: \(systemVersion)\nPlease describe your issue above this line."
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
                    if soundSetting { PlayUnlocked() }
                    TelemetryManager.send("GrownUpSettings",
                                          with: ["Passed?" : "\(showCheck)"])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        npP = ""
                        nP = ""
                        print("Correct numbers")
                        showSettings.toggle()
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
    
    func actionSheet() {
        guard let appShare = URL(string: "https://apps.apple.com/us/app/id1583086555") else { return }
        let av = UIActivityViewController(activityItems: [appShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2.1, y: UIScreen.main.bounds.height / 1.3, width: 200, height: 200)
        }
        TelemetryManager.send("ShareButtonPressed")
    }
    
}

struct GrownUpSettings_Previews: PreviewProvider {
    static var previews: some View {
        GrownUpSettings()
    }
}
