//
//  UserDefaultsHelper.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 15.09.24.
//

import Foundation

struct UserDefaultsHelper {
    private let remindersKey = "savedReminders"
    
    // Speichern der Erinnerungen
    func saveToUserDefaults(reminders: [Reminder]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reminders)
            UserDefaults.standard.set(data, forKey: remindersKey)
        } catch {
            print("Fehler beim Speichern der Erinnerungen: \(error)")
        }
    }
    
    // Laden der Erinnerungen
    func loadFromUserDefaults() -> [Reminder] {
        if let data = UserDefaults.standard.data(forKey: remindersKey) {
            do {
                let decoder = JSONDecoder()
                let reminders = try decoder.decode([Reminder].self, from: data)
                return reminders
            } catch {
                print("Fehler beim Laden der Erinnerungen: \(error)")
            }
        }
        return []
    }
}

