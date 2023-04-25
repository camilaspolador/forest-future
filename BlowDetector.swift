//
//  BlowDetector.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 09/04/23.
//

import AVFoundation

final class BlowDetector {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var detectionThreshold: Float
    
    init(detectionThreshold: Float) {
        self.detectionThreshold = detectionThreshold
    }
    
    func startDetecting() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self?.startRecording()
                    } else {
                        print("failed to record!")
                    }
                }
            }
        } catch {
            print("error recording session")
        }
    }
    
    private func startRecording() {
        let audioFilename = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording.caf")
        
        let settings = [
            AVFormatIDKey: kAudioFormatAppleIMA4,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 12800,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
        } catch {
            stop()
        }
    }
    
    func stop() {
        if audioRecorder == nil {
            return
        }
        
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func detectedBlow() -> Bool {
        if audioRecorder == nil {
            return false
        }
        
        self.audioRecorder.updateMeters()
        
        if audioRecorder.averagePower(forChannel: 0) > detectionThreshold {
            return true
        }
        
        return false
    }
    
    func getVolume (threshold: Float) -> Float? {
        if audioRecorder == nil {
            return nil
        }
        
        self.audioRecorder.updateMeters()
        
        let volume = audioRecorder.averagePower(forChannel: 0)
        print(volume)
        if volume > threshold {
            return volume
        }
        
        return nil
    }
}
