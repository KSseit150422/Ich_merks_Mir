//
//  File.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 14.09.24.
//

import Foundation

struct Reminder: Identifiable, Codable {
    var id = UUID()
    var name: String
    var texts: [String] = [] // Mehrere Texte können hier gespeichert werden
    var audioPath: String?
    var photoPaths: [String] = []
}

