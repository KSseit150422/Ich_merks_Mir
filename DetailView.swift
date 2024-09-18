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
                let fullPath = getDocumentsDirectory().appendingPathComponent(audioURL.lastPathComponent)
                
                VStack {
                    Text("Gespeichert unter: \(audioURL.lastPathComponent)")
                        .font(.footnote)
                        .padding()
                    
                    if FileManager.default.fileExists(atPath: fullPath.path) {
                        Text("Die Datei existiert und wird abgespielt.")
                            .font(.footnote)
                            .padding()
                        
                        Button(action: {
                            audioPlayer.startPlayback(audioURL: fullPath)
                        }) {
                            Image(systemName: audioPlayer.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(audioPlayer.isPlaying ? .red : .green)
                        }
                        .padding()
                        
                        if let attributes = try? FileManager.default.attributesOfItem(atPath: fullPath.path),
                           let fileSize = attributes[FileAttributeKey.size] as? NSNumber {
                            Text("Dateigröße: \(fileSize) Bytes")
                                .font(.footnote)
                                .padding()
                        }
                    } else {
                        Text("Die Datei existiert nicht. Überprüfe den Pfad.")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle(reminder.name) // NavigationTitle wird hier aufgerufen
        .onAppear {
            texts = reminder.texts
            images = reminder.photoPaths.compactMap { loadImage(from: $0) }
            
            if let audioPath = reminder.audioPath {
                let fullAudioPath = getDocumentsDirectory().appendingPathComponent(audioPath)
                if FileManager.default.fileExists(atPath: fullAudioPath.path) {
                    print("Dateipfad: \(fullAudioPath.path) existiert.")
                    audioRecorder.audioURL = fullAudioPath
                } else {
                    print("Die Audiodatei existiert nicht am Pfad: \(fullAudioPath.path)")
                }
            }
        }
            .onDisappear {
                    reminder.texts = texts
                    var savedPhotoPaths: [String] = []
                    for image in images {
                        if let savedImagePath = saveImage(image: image) {
                            savedPhotoPaths.append(savedImagePath)
                        }
                    }
                    reminder.photoPaths = savedPhotoPaths
                    if let audioURL = audioRecorder.audioURL {
                        reminder.audioPath = audioURL.lastPathComponent
                    }
                    helper.saveToUserDefaults(reminders: reminders)
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: Binding(
                        get: { nil },
                        set: { if let newImage = $0 { images.append(newImage) } }
                    ))
                }
        }
        
        func addNewText() {
            guard !newText.isEmpty else { return }
            texts.append(newText)
            newText = ""
        }
    }

