//
//  File.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 14.09.24.
//

import Foundation

struct Reminder: Identifiable, Codable {
    var id = UUID()
    var name: String  // Der Name der Liste
    var text: String  // Die Details der Erinnerung (Text)
    var audioPath: String?
    var photoPath: String?
}
