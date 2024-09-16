//
//  File.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 15.09.24.
//

import Foundation
import AVFoundation

class AudioRecorder: ObservableObject {
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false
    var audioURL: URL?

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,  // 44.1 kHz ist ein Standardwert für Audiodateien
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
            audioURL = audioFilename
            print("Aufnahme gestartet: \(audioFilename)")
        } catch {
            print("Fehler bei der Aufnahme: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        print("Aufnahme abgeschlossen, Datei gespeichert unter: \(audioURL?.path ?? "keine Datei")")
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


