//
//  RecordingsListView.swift
//  VoiceRecorderApp
//
//  Created by Ryan Klumph on 8/19/21.
//

import SwiftUI

struct RecordingsListView: View {
    
    @StateObject var audioRecorder: AudioRecorder
    @State var rowHeight: CGFloat = 90
    @State private var renamingURL: URL? = nil
    @State private var newFileName: String = ""
    @State private var showRenameSheet: Bool = false
    @FocusState private var isRenamingFieldFocused: Bool
    private let orderKey = "recordingsOrderV1"
    
    var body: some View {
        List {
            ForEach (audioRecorder.recordings, id: \.fileURL) { recording in
                RecordingRow(audioURL: recording.fileURL)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Rename") {
                            beginRename(for: recording.fileURL)
                        }.tint(.blue)
                    }
                    .contextMenu {
                        Button(action: { beginRename(for: recording.fileURL) }) {
                            Label("Rename", systemImage: "pencil")
                        }
                    }
            }
            .onDelete(perform: delete)
            .onMove(perform: onMove)
            .environment(\.defaultMinListRowHeight, rowHeight)
        }
        .onAppear {
            ensureOrderInitialized()
            applySavedOrder()
        }
        .onReceive(audioRecorder.objectWillChange) { _ in
            // Apply saved order after any fetch/refresh from AudioRecorder
            ensureOrderInitialized()
            applySavedOrder()
        }
        .sheet(isPresented: $showRenameSheet) {
            NavigationView {
                Form {
                    TextField("New name", text: $newFileName)
                        .focused($isRenamingFieldFocused)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onAppear { isRenamingFieldFocused = true }
                    if let url = renamingURL {
                        Text("Will be saved as: \(newFileName.isEmpty ? url.deletingPathExtension().lastPathComponent : newFileName).\(url.pathExtension)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("Rename Recording")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showRenameSheet = false
                            renamingURL = nil
                            newFileName = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { performRename() }
                            .disabled(newFileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }
    private func onMove(source: IndexSet, destination: Int) {
        audioRecorder.recordings.move(fromOffsets: source, toOffset: destination)
        saveOrder()
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
        saveOrder()
    }

    private func beginRename(for url: URL) {
        newFileName = url.deletingPathExtension().lastPathComponent
        renamingURL = url
        showRenameSheet = true
    }

    private func performRename() {
        guard let sourceURL = renamingURL else { return }
        var sanitized = newFileName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitized.isEmpty else { return }
        // Replace characters that are problematic in filenames
        let invalid = CharacterSet(charactersIn: "/:\\?%*|\"<>")
        sanitized = sanitized.components(separatedBy: invalid).joined(separator: "-")

        let targetURL = sourceURL.deletingLastPathComponent()
            .appendingPathComponent(sanitized)
            .appendingPathExtension(sourceURL.pathExtension)

        // If a file with the new name exists, append a number
        var finalURL = targetURL
        var counter = 2
        while FileManager.default.fileExists(atPath: finalURL.path) {
            finalURL = sourceURL.deletingLastPathComponent()
                .appendingPathComponent("\(sanitized) \(counter)")
                .appendingPathExtension(sourceURL.pathExtension)
            counter += 1
        }

        do {
            try FileManager.default.moveItem(at: sourceURL, to: finalURL)
            // Refresh the list
            audioRecorder.fetchRecordings()
            if var saved = UserDefaults.standard.stringArray(forKey: orderKey),
               let oldIndex = saved.firstIndex(of: sourceURL.lastPathComponent) {
                saved[oldIndex] = finalURL.lastPathComponent
                UserDefaults.standard.set(saved, forKey: orderKey)
            }
            // Re-apply saved order to the refreshed list
            applySavedOrder()
        } catch {
            print("Rename failed: \(error)")
        }

        // Reset state
        showRenameSheet = false
        renamingURL = nil
        newFileName = ""
    }

    private func saveOrder() {
        let names = audioRecorder.recordings.map { $0.fileURL.lastPathComponent }
        UserDefaults.standard.set(names, forKey: orderKey)
    }

    private func ensureOrderInitialized() {
        if UserDefaults.standard.stringArray(forKey: orderKey) == nil {
            saveOrder()
        }
    }

    private func applySavedOrder() {
        guard let saved = UserDefaults.standard.stringArray(forKey: orderKey), !saved.isEmpty else { return }
        audioRecorder.recordings.sort { a, b in
            let ia = saved.firstIndex(of: a.fileURL.lastPathComponent) ?? Int.max
            let ib = saved.firstIndex(of: b.fileURL.lastPathComponent) ?? Int.max
            return ia < ib
        }
    }
}

struct RecordingRow: View {
    
    @AppStorage("isHuman") var isHuman: Bool = true
    @AppStorage("isChipmpunk") var isChipmpunk: Bool = false
    @AppStorage("isMonster") var isMonster: Bool = false
    @AppStorage("isRobot") var isRobot: Bool = false
    @AppStorage("isEcho") var isEcho: Bool = false
    @AppStorage("isClown") var isClown: Bool = false
    @AppStorage("isAlien") var isAlien: Bool = false
    @AppStorage("isRadio") var isRadio: Bool = false
    
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            if #available(iOS 15, *) {
            Image(systemName: "music.mic.circle")
                .font(.title)
            } else {
                Image(systemName: "mic.circle")
                    .font(.title)
            }
            Text("\(audioURL.lastPathComponent)")
                .font(.title2)
                .gradientForeground(colors: [Color("neonblue"), Color("neonpink")])
            Spacer()
            
            if audioPlayer.isPlaying == false {
                Button(action: {
                    if isHuman {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                    }
                    
                    if isChipmpunk {
                        self.audioPlayer.speedControl.rate = 1.8

                        do {
                            try self.audioPlayer.play(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Chipmunk")
                    }
                    if isMonster {
                        self.audioPlayer.speedControl.rate = 0.7
                        self.audioPlayer.pitchControl.rate = 1.3
                        //self.audioPlayer.speedControl.rate = 0.4
                        //self.audioPlayer.pitchControl.rate = 2.7

                        do {
                            try self.audioPlayer.play(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Monster")
                    }
                    if isRobot {
                        self.audioPlayer.distortionControl.loadFactoryPreset(.speechGoldenPi)
                        self.audioPlayer.distortionControl.wetDryMix = 75
                        do {
                            try self.audioPlayer.playRobot(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Robot")
                    }
                    if isEcho {
                        self.audioPlayer.echoControl.loadFactoryPreset(.cathedral)
                        self.audioPlayer.echoControl.wetDryMix = 40
                        do {
                            try self.audioPlayer.playEcho(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Echo")
                    }
                    if isClown {
                        self.audioPlayer.distortionControl.loadFactoryPreset(.drumsBitBrush)
                        self.audioPlayer.distortionControl.wetDryMix = 20
                        self.audioPlayer.delayEffect.delayTime = 0.1

                        do {
                            try self.audioPlayer.playClown(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Clown")
                    }
                    if isAlien {
                        self.audioPlayer.distortionControl.loadFactoryPreset(.multiBrokenSpeaker)

                        do {
                            try self.audioPlayer.playAlien(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Alien")
                    }
                    if isRadio {
                        self.audioPlayer.distortionControl.loadFactoryPreset(.multiDecimated3)

                        do {
                            try self.audioPlayer.playRadio(self.audioURL)
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        print("Playing Radio")
                    }

                }) {
                    
                    Image(systemName: "play.circle")
                        //.imageScale(.large)
                        .font(.title)
                        .foregroundColor(Color("neonyellow")) // shouldn't be needed for iOS 15
                }
            } else {
                Button(action: {
                    if isHuman {
                    self.audioPlayer.stopPlayback()
                    } else {
                        self.audioPlayer.stopPlayback2()
                    }
                    print("Stop playing audio")
                }) {
                    LottieView(animationName: "audioyellow", loopMode: .loop, contentMode: .scaleAspectFill)
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

struct RecordingsListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsListView(audioRecorder: AudioRecorder())
    }
}
