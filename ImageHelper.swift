//
//  ImageHelper.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 15.09.24.
//

import UIKit

// Funktion zum Laden eines Bildes vom Dateipfad
func loadImage(from path: String?) -> UIImage? {
    guard let path = path else { return nil }
    let fullPath = getDocumentsDirectory().appendingPathComponent(path)
    return UIImage(contentsOfFile: fullPath.path)
}

// Funktion zum Speichern eines Bildes und Rückgabe des Pfades
func saveImage(image: UIImage) -> String? {
    guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
    let filename = UUID().uuidString + ".jpg"
    let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
    
    do {
        try data.write(to: fullPath)
        return filename
    } catch {
        print("Fehler beim Speichern des Bildes: \(error)")
        return nil
    }
}
