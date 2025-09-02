//
//  AudioRecorder.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/19/21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
let generator = UINotificationFeedbackGenerator()


class AudioRecorder: NSObject, ObservableObject {
    
    @AppStorage("recordingDuration") var recordingDuration: Int = 0
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent(" \(Date().toString(dateFormat: "MM-dd-YY  'at'  HH:mm:ss"))")
       // let audioFilename = documentPath.appendingPathComponent("Yak #\(self.recordings.count + 1) - \(Date().toString(dateFormat: "MM-dd-YY"))")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            if recordingDuration == 0 {
                audioRecorder.record(forDuration: 6)
            }
            if recordingDuration == 1 {
                audioRecorder.record(forDuration: 10)
            }
            if recordingDuration == 2 {
                audioRecorder.record(forDuration: 15)
            }
            if recordingDuration == 3 {
                audioRecorder.record(forDuration: 25)
            }
            if recordingDuration == 4 {
                audioRecorder.record(forDuration: 60)
            }
            recording = true
        } catch {
            print(error.localizedDescription)
        }
    }

    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        generator.notificationOccurred(.success)
        fetchRecordings()
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
        objectWillChange.send(self)
        
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        fetchRecordings()
        
    }
}

