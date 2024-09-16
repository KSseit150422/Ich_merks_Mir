//
//  ContentView.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 14.09.24.
//

import SwiftUI

struct ListView: View {
    @State private var reminders: [Reminder] = []
    @State private var newReminderName: String = ""
    let helper = UserDefaultsHelper()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(reminders.indices, id: \.self) { index in
                        NavigationLink(destination: DetailView(reminder: $reminders[index])) {
                            Text(reminders[index].name)
                        }
                    }
                    .onDelete(perform: deleteReminder)
                }
                
                HStack {
                    TextField("Neue Liste", text: $newReminderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: addNewReminder) {
                        Text("Hinzufügen")
                    }
                    .padding()
                }
            }
            .navigationTitle("Erinnerungen")
            .onAppear {
                loadReminders()
            }
        }
    }
    
    func addNewReminder() {
        guard !newReminderName.isEmpty else { return }
        let newReminder = Reminder(name: newReminderName, text: "", audioPath: nil, photoPath: nil)
        reminders.append(newReminder)
        helper.saveToUserDefaults(reminders: reminders)
        newReminderName = ""
    }
    
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
        helper.saveToUserDefaults(reminders: reminders)
    }
    
    func loadReminders() {
        reminders = helper.loadFromUserDefaults()
    }
}

