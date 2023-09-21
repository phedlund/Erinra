//
//  NewReminder.swift
//  Erinra
//
//  Created by Peter Hedlund on 9/3/23.
//

import SwiftUI
import UserNotifications

struct NewReminder: View {
    @Environment(\.modelContext) private var modelContext

    @FocusState private var titleInFocus: Bool
    
    @State private var title = ""
    @State private var note = ""
    @State private var date = Date.now
    @State private var isReminding = false
    
    var reminder: Reminder?
    @Binding var isShowingAdd: Bool

    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $title)
                    .focused($titleInFocus)
                TextField("Note", text: $note)
                Toggle(isOn: $isReminding) {
                    DatePicker(selection: $date,
                               in: Date.now...Date.distantFuture,
                               displayedComponents: [.date, .hourAndMinute]) {
                        Text("Remind on")
                    }
                    .disabled(!isReminding)
                }
                HStack {
                    Spacer()
                    Button {
                        isShowingAdd = false
                    } label: {
                        Text("Cancel")
                    }
                    .keyboardShortcut(.cancelAction)
                    Button {
                        var item: Reminder
                        if let reminder {
                            reminder.note = note
                            reminder.reminder = isReminding
                            reminder.reminderDate = date
                            reminder.title = title
                            item = reminder
                        } else {
                            item = Reminder(note: note,
                                            reminder: isReminding,
                                            reminderDate: date,
                                            title: title)
                        }
                        modelContext.insert(item)
                        do {
                            try modelContext.save()
                            if isReminding {
                                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                NotificationManager.shared.addNotification(id: NotificationManager.notificationId, title: title, subtitle: note, trigger: trigger)
                            }
                        } catch {
                            print(error)
                        }
                        isShowingAdd = false
                    } label: {
                        Text("Add")
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(title.isEmpty)
                }
                Spacer()
            }
        }
        .padding()
        .task {
            if let reminder {
                note = reminder.note
                isReminding = reminder.reminder
                date = reminder.reminderDate
                title = reminder.title
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              self.titleInFocus = true
            }
        }
    }
}

#Preview {
    NewReminder(isShowingAdd: Binding(projectedValue: .constant(true)))
}
