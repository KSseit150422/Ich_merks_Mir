//
//  AudioPlayer.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 15.09.24.
//

import Foundation
import AVFoundation
import SwiftUI

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false

    func startPlayback(audioURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
            isPlaying = true
            print("Wiedergabe gestartet: \(audioURL)")
        } catch {
            print("Fehler beim Abspielen der Audiodatei: \(error.localizedDescription)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
}

