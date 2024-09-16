//
//  File.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 14.09.24.
//

import SwiftUI

struct DetailView: View {
    @Binding var reminder: Reminder
    @Binding var reminders: [Reminder]  // Das gesamte Array von Erinnerungen
    @State private var images: [UIImage] = []  // Speichere mehrere Bilder
    @State private var texts: [String] = []  // Speichere mehrere Texte
    @State private var newText: String = ""  // Der neue Text, der hinzugefügt wird
    @State private var showingImagePicker = false
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var audioPlayer = AudioPlayer()
    let helper = UserDefaultsHelper()  // Für die Speicherung

    var body: some View {
        VStack {
            ScrollView {
                // Zeige alle gespeicherten Texte an
                ForEach(texts.indices, id: \.self) { index in
                    VStack {
                        TextEditor(text: Binding(
                            get: { texts[index] },
                            set: { texts[index] = $0 }
                        ))
                        .frame(minHeight: 100)
                        .padding()
                        .border(Color.gray, width: 1)

                        Button(action: {
                            // Text löschen
                            texts.remove(at: index)
                        }) {
                            Text("Text löschen")
                                .foregroundColor(.red)
                        }
                    }
                }

                // Zeige alle gespeicherten Bilder an
                ForEach(images.indices, id: \.self) { index in
                    VStack {
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()

                        Button(action: {
                            // Bild löschen
                            images.remove(at: index)
                            reminder.photoPaths.remove(at: index)
                        }) {
                            Text("Foto löschen")
                                .foregroundColor(.red)
                        }
                    }
                }
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

                TextField("Neuen Text eingeben", text: $newText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding()

                Button(action: {
                    addNewText()
                }) {
                    Text("Hinzufügen")
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))

            if audioRecorder.isRecording {
                WaveformView(isRecording: $audioRecorder.isRecording)
                    .frame(height: 50)
                    .padding()
            }

            if let audioURL = audioRecorder.audioURL {
                Text("Gespeichert unter: \(audioURL.lastPathComponent)")
                    .font(.footnote)
                    .padding()

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
            texts = reminder.texts // Lade gespeicherte Texte
            images = reminder.photoPaths.compactMap { loadImage(from: $0) } // Lade gespeicherte Bilder
            
            if let audioPath = reminder.audioPath {
                let fullAudioPath = getDocumentsDirectory().appendingPathComponent(audioPath)
                if FileManager.default.fileExists(atPath: fullAudioPath.path) {
                    audioRecorder.audioURL = fullAudioPath
                }
            }
        }
        .onDisappear {
            reminder.texts = texts // Speichere Texte
            var savedPhotoPaths: [String] = []
            for image in images {
                if let savedImagePath = saveImage(image: image) {
                    savedPhotoPaths.append(savedImagePath)
                }
            }
            reminder.photoPaths = savedPhotoPaths // Speichere Bilder
            if let audioURL = audioRecorder.audioURL {
                reminder.audioPath = audioURL.lastPathComponent
            }
            helper.saveToUserDefaults(reminders: reminders) // Speichere die Daten
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: Binding(
                get: { nil },
                set: { if let newImage = $0 { images.append(newImage) } }
            ))
        }
    }

    // Funktion zum Hinzufügen eines neuen Textes
    func addNewText() {
        guard !newText.isEmpty else { return }
        texts.append(newText)
        newText = ""  // Leere das Textfeld nach dem Hinzufügen
    }
}








