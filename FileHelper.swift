//
//  FileHelper.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 15.09.24.
//

import Foundation

// Hilfsfunktion zum Ermitteln des Dokumentenverzeichnisses
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
