//
//  AudioPlayer.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/19/21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation


class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @AppStorage("playedFirstSound") var playedFirstSound = false
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    var isPlaying = false {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
              }
            
        }
    }

    
    var audioPlayer: AVAudioPlayer!
    
    /// Prepare the AVAudioSession and output route for reliable playback
    func prepareForPlayback() {
        let session = AVAudioSession.sharedInstance()

        // Stop any engine that could be holding onto I/O from previous effects playback
        if engine.isRunning {
            engine.stop()
            engine.reset()
        }

        // Stop any legacy AVAudioPlayer if it's mid‑play
        if let p = audioPlayer, p.isPlaying {
            p.stop()
        }

        do {
            // Use .playback for the cleanest speaker routing; default to speaker and allow BT
            try session.setCategory(.playback,
                                    mode: .default,
                                    options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP, .mixWithOthers])
            try session.setActive(true, options: [])

            // If we’re on the receiver, bump to speaker explicitly
            if session.currentRoute.outputs.first?.portType == .builtInReceiver {
                try? session.overrideOutputAudioPort(.speaker)
            }
        } catch {
            print("prepareForPlayback failed: \(error)")
        }
    }
    
    func startPlayback (audio: URL) {
        // Ensure session and route are correct before starting
        prepareForPlayback()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed: \(error)")
        }
    }
    
    func stopPlayback() {
        
        audioPlayer.stop()
        isPlaying = false
        playedFirstSound = true
        StoreReviewHelper.checkAndAskForReview()
        
    }
    
    func stopPlayback2() {
        engine.stop()
        engine.reset()
        isPlaying = false
        StoreReviewHelper.checkAndAskForReview()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            playedFirstSound = true
            print("Playback Stopped")
            StoreReviewHelper.checkAndAskForReview()
        }
    }
    
    // MARK: Below From https://www.hackingwithswift.com/example-code/media/how-to-control-the-pitch-and-speed-of-audio-using-avaudioengine
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    let echoControl = AVAudioUnitReverb()
    let distortionControl = AVAudioUnitDistortion()
    let delayEffect = AVAudioUnitDelay()

    
    func play(_ url: URL) throws {
        // Ensure the session/route are correct before building the engine graph
        prepareForPlayback()
        // 1: load the file
        let file = try! AVAudioFile(forReading: url)

        // 2: create the audio player
        let avPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(avPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(avPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        // Combo of https://stackoverflow.com/questions/69003265/how-to-monitor-for-avaudioplayernode-finished-playing
        // and https://stackoverflow.com/questions/29427253/completionhandler-of-avaudioplayernode-schedulefile-is-called-too-early
        // for the completion and .dataPlayedBack

        avPlayer.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { _ in
            self.stopPlayback2()
            print("Engine done playing")
            StoreReviewHelper.checkAndAskForReview()
        }
    

        // 6: start the engine and player
        isPlaying = true
        try engine.start()
        avPlayer.play()
    }
    
    func playAlien(_ url: URL) throws {
        // Ensure the session/route are correct before building the engine graph
        prepareForPlayback()
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let avPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(avPlayer)
        //engine.attach(pitchControl)
        engine.attach(distortionControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(avPlayer, to: distortionControl, format: nil)
        engine.connect(distortionControl, to: engine.mainMixerNode, format: nil)
        //engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        //avPlayer.scheduleFile(file, at: nil)
        avPlayer.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { _ in
            self.stopPlayback2()
            print("Engine done playing")
            StoreReviewHelper.checkAndAskForReview()
        }

        // 6: start the engine and player
        isPlaying = true
        try engine.start()
        avPlayer.play()
    }
    
    func playEcho(_ url: URL) throws {
        // Ensure the session/route are correct before building the engine graph
        prepareForPlayback()
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let avPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(avPlayer)
        engine.attach(echoControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(avPlayer, to: echoControl, format: nil)
        engine.connect(echoControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        //avPlayer.scheduleFile(file, at: nil)
        avPlayer.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { _ in
            self.stopPlayback2()
            print("Engine done playing")
            StoreReviewHelper.checkAndAskForReview()
        }

        // 6: start the engine and player
        isPlaying = true
        try engine.start()
        avPlayer.play()
    }
    
    func playClown(_ url: URL) throws {
        // Ensure the session/route are correct before building the engine graph
        prepareForPlayback()
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let avPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(avPlayer)
        engine.attach(distortionControl)
        engine.attach(delayEffect)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(avPlayer, to: distortionControl, format: nil)
        engine.connect(distortionControl, to: delayEffect, format: nil)
        engine.connect(delayEffect, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        avPlayer.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { _ in
            self.stopPlayback2()
            print("Engine done playing")
            StoreReviewHelper.checkAndAskForReview()
        }

        // 6: start the engine and player
        isPlaying = true
        try engine.start()
        avPlayer.play()
    }
    
    func playRobot(_ url: URL) throws {
        // Ensure the session/route are correct before building the engine graph
        prepareForPlayback()
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let avPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(avPlayer)
        //engine.attach(pitchControl)
        engine.attach(distortionControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(avPlayer, to: distortionControl, format: nil)
        engine.connect(distortionControl, to: engine.mainMixerNode, format: nil)
        //engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        //avPlayer.scheduleFile(file, at: nil)
        avPlayer.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { _ in
            self.stopPlayback2()
            print("Engine done playing")
            StoreReviewHelper.checkAndAskForReview()
        }

        // 6: start the engine and player
        isPlaying = true
        try engine.start()
        avPlayer.play()
    }
    
    func playRadio(_ url: URL) throws {
        // Ensure the session/route are correct before building the engine graph
        prepareForPlayback()
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let avPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(avPlayer)
        //engine.attach(pitchControl)
        engine.attach(distortionControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(avPlayer, to: distortionControl, format: nil)
        engine.connect(distortionControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        //avPlayer.scheduleFile(file, at: nil)
        avPlayer.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { _ in
            self.stopPlayback2()
            print("Engine done playing")
            StoreReviewHelper.checkAndAskForReview()
        }

        // 6: start the engine and player
        isPlaying = true
        try engine.start()
        avPlayer.play()
        
    }
}
