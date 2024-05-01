//
//  LMChatAudioRecordManager.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 19/04/24.
//

import AVFoundation

public final class LMChatAudioRecordManager {
    static let shared = LMChatAudioRecordManager()
    
    private var session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
    private var updater: Timer?
    private var url: URL?
    private var audioDuration = 0
    
    public var audioURL: URL? { url }
    
    private init() { }
    
    private func activateSession() {
        do {
            try session.setCategory(.record, mode: .spokenAudio, options: .allowBluetooth)
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
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let timeVariable = String(Int(Date().timeIntervalSince1970))
        let recordingName = "\(timeVariable)_voiceRecording.aac"
        let pathArray = [dirPath, recordingName]
        print(pathArray)
        url = URL(string: pathArray.joined(separator: "/"))
        
        guard let url else { return false }
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVLinearPCMIsNonInterleaved: false,
            AVSampleRateKey: 44_100.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        FileManager.default.createFile(atPath: url.absoluteString, contents: nil)
        
        recorder = try AVAudioRecorder(url: url, settings: settings)
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
    
    @discardableResult
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
    
    public func resetAudioParameters() {
        audioDuration = .zero
        recorder = nil
    }
    
    public func deleteAudioRecording() {
        endAudioRecording()
        resetAudioParameters()
        
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
