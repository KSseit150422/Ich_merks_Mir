//
//  File.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 14.09.24.
//

import SwiftUI

struct DetailView: View {
    @Binding var reminder: Reminder
    @State private var noteText: String = ""
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var audioPlayer = AudioPlayer()

    var body: some View {
        VStack {
            ScrollView {
                if let image = image {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()

                        Button(action: {
                            self.image = nil
                            reminder.photoPath = nil
                        }) {
                            Text("Foto löschen")
                                .foregroundColor(.red)
                        }
                    }
                }

                TextEditor(text: $noteText)
                    .frame(minHeight: 100)
                    .padding()
                    .border(Color.gray, width: 1)
            }

            Spacer()

            HStack {
                Button(action: {
                    showingImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                }
                .padding()

                Button(action: {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    } else {
                        audioRecorder.startRecording()
                    }
                }) {
                    Image(systemName: audioRecorder.isRecording ? "stop.fill" : "mic.fill")
                        .font(.largeTitle)
                        .foregroundColor(audioRecorder.isRecording ? .red : .blue)
                }
                .padding()

                TextField("Notizen eingeben", text: $noteText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))

            if audioRecorder.isRecording {
                WaveformView(isRecording: $audioRecorder.isRecording)
                    .frame(height: 50)
                    .padding()
            }

            // Zeige den Pfad zur gespeicherten Audiodatei an
            if let audioURL = audioRecorder.audioURL {
                Text("Gespeichert unter: \(audioURL.lastPathComponent)")
                    .font(.footnote)
                    .padding()

                // Abspielen oder Stoppen der Audiodatei
                Button(action: {
                    let fullPath = getDocumentsDirectory().appendingPathComponent(audioURL.lastPathComponent)
                    print("Versuche, die Datei abzuspielen: \(fullPath.path)")
                    if FileManager.default.fileExists(atPath: fullPath.path) {
                        print("Die Datei existiert und wird abgespielt.")
                        audioPlayer.startPlayback(audioURL: fullPath)
                    } else {
                        print("Die Datei existiert nicht. Überprüfe den Pfad.")
                    }
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(audioPlayer.isPlaying ? .red : .green)
                }
            }
        }
        .navigationTitle(reminder.name)
        .onAppear {
            noteText = reminder.text
            image = loadImage(from: reminder.photoPath)
        }
        .onDisappear {
            reminder.text = noteText
            if let savedImage = image {
                reminder.photoPath = saveImage(image: savedImage)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            CameraView(image: $image)
        }
    }
}






