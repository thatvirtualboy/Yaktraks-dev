//
//  ContentView.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/19/21.
//
// TUTORIAL: https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

import SwiftUI
import AVFAudio

struct ContentView: View {
    
    enum Sheet { case whatsNew }
    @State var sheet: Sheet? = nil
    
    @ObservedObject var audioRecorder: AudioRecorder
    @State var showBolt = false
    @State var showButton = true
    @AppStorage("recordingDuration") var recordingDuration: Int = 0
    @State private var workItem: DispatchWorkItem?
    @AppStorage("recordCount") var recordCount: Int = 0
    @State var showInstructions = false
    @AppStorage("playedFirstSound") var playedFirstSound = false
    @AppStorage("soundSetting") var soundSetting = true
    let generator = UINotificationFeedbackGenerator()
    @State private var CompletePlayer: AVAudioPlayer?
    
    // Clock Settings//
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var counter: Int = 0
    @State var countTo: Int = 6
    @State var timerRunning = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LottieView(animationName: "dots", loopMode: .loop, contentMode: .scaleAspectFill)
                    .ignoresSafeArea()
                // SHOW Lightning Bolt when recording done
                if showBolt {
                    
                    VStack {
                        Text("Rock On!")
                            .font(Font.custom("BungeeInline-Regular", size: 50))
                            .foregroundColor(Color("neonyellow"))
                        LottieView(animationName: "bolt", loopMode: .playOnce, contentMode: .scaleAspectFit)
                        
                    }
                    .animation(.easeInOut)
                    .onAppear {
                        if soundSetting { PlayComplete() }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            showBolt = false
                            showButton = true
                        }
                    }
                }
                
                
                VStack {
                    if showButton {
                        
                        if audioRecorder.recording == false {
                            VStack {
                                Spacer()
                                Text("Tap to \nrecord")
                                    .font(Font.custom("BungeeInline-Regular", size: 50))
                                    .foregroundColor(Color("neonpink"))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                Button(action: {
                                    if soundSetting { PlayStart() }
                                    self.generator.notificationOccurred(.success)
                                    print("Start recording")
                                    
                                    // Below to avoid recording the start sound
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.audioRecorder.startRecording()
                                    recordCount = recordCount + 1
                                    print("Recording Count: \(recordCount)")
                                    }
                                }) {
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                        LottieView(animationName: "button", loopMode: .loop, contentMode: .scaleAspectFit)
                                            .frame(width: 300, height: 300)
                                            .opacity(showInstructions ? 0 : 1)
                                    } else {
                                        LottieView(animationName: "button", loopMode: .loop, contentMode: .scaleAspectFit)
                                            .opacity(showInstructions ? 0 : 1)
                                    }
                                }
                                Spacer()
                            }
                            .blur(radius: showInstructions ? 5 : 0)
                            .onAppear {
                                self.stopTimer()
                                if recordingDuration == 0 { self.countTo = 6 }
                                if recordingDuration == 1 { self.countTo = 10 }
                                if recordingDuration == 2 { self.countTo = 15 }
                                if recordingDuration == 3 { self.countTo = 25 }
                                if recordingDuration == 4 { self.countTo = 60 }
                                print("Recording Duration value: \(recordingDuration)")
                                print("CountTo Value: \(countTo)")
                            }
                        } else {
                            VStack {
                                Text("Recording")
                                    .font(Font.custom("BungeeInline-Regular", size: 50))
                                    .foregroundColor(Color("neonred"))
                                    .multilineTextAlignment(.center)
                                LottieView(animationName: "audioyellow", loopMode: .loop, contentMode: .scaleAspectFit)
                                Button(action: {
                                    print("Stop recording")
                                    self.audioRecorder.stopRecording()
                                    showBolt = true
                                    showButton = false
                                    timerRunning = false
                                    self.stopTimer()
                                    workItem?.cancel()
                                    self.generator.notificationOccurred(.success)
                                    checkRecordingCount()
                                    StoreReviewHelper.checkAndAskForReview()
                                }) {
                                    Image(systemName: "square.fill")
                                        .resizable()
                                        .animation(.easeIn)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                        .foregroundColor(Color("neonred"))
                                        .padding(.bottom, 40)
                                        .shadow(radius: 10)
                                }
                            }
                            .onAppear {
                                startTimer()
                                
                                if recordingDuration == 0 {
                                    workItem = DispatchWorkItem { timerEndedOperations() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: workItem!)
                                }
                                if recordingDuration == 1 {
                                    workItem = DispatchWorkItem { timerEndedOperations() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: workItem!)
                                }
                                if recordingDuration == 2 {
                                    workItem = DispatchWorkItem { timerEndedOperations() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: workItem!)
                                }
                                if recordingDuration == 3 {
                                    workItem = DispatchWorkItem { timerEndedOperations() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 25.0, execute: workItem!)
                                }
                                if recordingDuration == 4 {
                                    workItem = DispatchWorkItem { timerEndedOperations() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 60.0, execute: workItem!)
                                }
                                
                            }
                        }
                    }
                    Spacer()
                    
                    
                    /*
                     Count Down
                     */
                    
                    HStack {
                        Spacer()
                        
//                        if audioRecorder.recording == false {
                            
                            if countTo == 6 {
                            Text("6s")
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                            }
                            if countTo == 10 {
                            Text("10s")
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                            }
                            if countTo == 15 {
                            Text("15s")
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                            }
                            if countTo == 25 {
                            Text("25s")
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                            }
                            if countTo == 60 {
                            Text("60s")
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                            }
//                        } else {
//
//                        VStack { Clock(counter: counter, countTo: countTo) }
//                            .onReceive(timer) { _ in
//                                if self.timerRunning {
//                                    self.stopTimer()
//                                } else {
//
//                                    if (self.counter < self.countTo) {
//                                        self.counter += 1
//
//                                    }
//                                }
//                            }
//                        }
                    }
                    .opacity(showInstructions ? 0 : 1)
                    
                    // MARK: Arrow for first time recording
                    
                    if showInstructions {
                    LottieView(animationName: "arrowyellow", loopMode: .loop, contentMode: .scaleAspectFit)
                        .frame(width: 300, height: 300)
                    }
                }
                .sheet(using: $sheet) { sheet in
                    switch sheet {
                    case .whatsNew:
                        WhatsNewHighlightView()
                    }
                }
            }
            
            // MARK: For testing only -- disable for prod
//            .onAppear {
//                sheet = .whatsNew
//            }

        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
                checkForUpdate()
            checkRecordingCount()
            }
        }
    
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        
        //return "\(seconds < 10 ? "" : "")\(seconds)"
        return "\(seconds)"
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
    
    func completed() -> Bool {
        return progress() == 1
        
    }
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        print("Recording Duration value: \(recordingDuration)")
        print("CountTo Value: \(countTo)")
        
    }
    func timerEndedOperations() {
        print("Timer ended. Recording stopped.")
        self.audioRecorder.stopRecording()
        showBolt = true
        showButton = false
        timerRunning = false
        self.stopTimer()
        checkRecordingCount()
    }
    
    // Get current Version of the App
    func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        print(version)
        return version
    }
    
    func checkRecordingCount() {
        if playedFirstSound == false && recordCount == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                showInstructions = true
            }
        } else {
            showInstructions = false
        }
    }
    
    func PlayStart() {
    if let CompleteSound = Bundle.main.url(forResource: "start", withExtension: "wav") {
                do {
                    try CompletePlayer = AVAudioPlayer(contentsOf: CompleteSound) /// make the audio player
                    CompletePlayer?.volume = 2
                    CompletePlayer?.play()
                } catch {
                print("Couldn't play audio. Error: \(error)")
                }
                    }
    }
    
    func PlayComplete() {
    if let CompleteSound = Bundle.main.url(forResource: "rockon", withExtension: "wav") {
                do {
                    try CompletePlayer = AVAudioPlayer(contentsOf: CompleteSound) /// make the audio player
                    CompletePlayer?.volume = 2
                    CompletePlayer?.play()
                } catch {
                print("Couldn't play audio. Error: \(error)")
                }
                    }
    }

    // Check if app if app has been started after update
    func checkForUpdate() {
        let version = getCurrentAppVersion()
        let savedVersion = UserDefaults.standard.string(forKey: "savedVersion")
        
        if savedVersion == version {
            print("App is up to date!")
        } else {
            
            // Toggle to show WhatsNew Screen as Modal
            sheet = .whatsNew
            UserDefaults.standard.set(version, forKey: "savedVersion")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
