//
//  SoundManager.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 17/04/23.
//
import AVFoundation

class SoundManager : ObservableObject {
    
    private var soundDict: [Sound:AVAudioPlayer?] = [:]
    
    init() {
        for sound in Sound.allCases {
            soundDict[sound] = getAudioPlayer(sound: sound)
        }
    }
    
    private func getAudioPlayer(sound: Sound) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(
            forResource: sound.rawValue,
            withExtension: ".m4a"
        ) else {
            print("Fail to get url for \(sound)")
            return nil
        }

        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            return audioPlayer
        } catch {
            print("Fail to load \(sound)")
            return nil
        }
    }
    
    func playLoop(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func play(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.play()
    }
    
    func pause(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.pause()
    }
    
    func stop(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.currentTime = 0
        audioPlayer.pause()
    }
    
    enum Sound: String, CaseIterable {
        case backgroundb
        case buttons
        case correct
        case forest
        case texts
        case wings
        case pollenn
        case door
        case waterr
        case lightt
        case clickButton
        case subs
        case river
        case calm
        case germinationsong
    }
}
