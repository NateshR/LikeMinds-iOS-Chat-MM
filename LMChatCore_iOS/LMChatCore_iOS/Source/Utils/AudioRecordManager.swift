//
//  AudioRecordManager.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 19/04/24.
//

import AVFoundation

public final class AudioRecordManager {
    static let shared = AudioRecordManager()
    
    private var session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
    private var updater: Timer?
    private var audioFileName = "recording.m4a"
    private var url: URL?
    private var audioDuration = 0
    
    public var audioURL: URL? { url }
    
    private init() { }
    
    private func activateSession() {
        do {
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: .allowBluetooth)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func recordAudio(audioDelegate: AVAudioRecorderDelegate) throws -> Bool {
        activateSession()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        url = documentDirectory.appendingPathComponent(audioFileName)
        
        guard let url else { return false }
        
        FileManager.default.createFile(atPath: url.absoluteString, contents: nil)
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue]
        
        recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder?.isMeteringEnabled = true
        recorder?.delegate = audioDelegate
        
        if recorder?.prepareToRecord() == true {
            recorder?.record()
        } else {
            return false
        }
        
        updater = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateAudioTimer),
            userInfo: nil,
            repeats: true)
        
        return recorder?.isRecording ?? false
    }
        
    @objc
    private func updateAudioTimer() {
        audioDuration += 1
        NotificationCenter.default.post(name: .audioDurationUpdate, object: audioDuration)
    }
    
    
    func recordingStopped() -> URL? {
        if audioDuration > 1 {
            endAudioRecording()
            return url
        }
        
        deleteAudioRecording()
        return nil
    }
    
    private func endAudioRecording() {
        updater?.invalidate()
        updater = nil
        recorder?.pause()
    }
    
    public func deleteAudioRecording() {
        audioDuration = .zero
        recorder = nil
        endAudioRecording()
        
        do {
            guard let url else { return }
            print("Removing audio -> \(url)")
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
        
        url = nil
    }
}


public extension Notification.Name {
    static let audioDurationUpdate = Notification.Name("Audio Duration Updated")
}