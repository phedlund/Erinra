//
//  NewReminder.swift
//  Erinra
//
//  Created by Peter Hedlund on 9/3/23.
//

import SwiftUI
import UserNotifications

struct NewReminder: View {
    private enum FocusedField {
        case title
        case notes
    }

    @Environment(\.modelContext) private var modelContext

    @AppStorage("TappingOutside") var isTappingOutside: Bool = false

    @FocusState private var focusedField: FocusedField?
    
    @State private var title = ""
    @State private var note = ""
    @State private var date = Date.now
    @State private var isReminding = false
    @State private var isDateChanged = false
    
    var reminder: Reminder?
    @Binding var isShowingAdd: Bool
    var isEditing: Bool

    var body: some View {
        HStack(alignment: .top) {
            if isEditing {
                EmptyView()
            } else {
                Button {
                    //
                } label: {
                    Image(systemName: "circle")
                }
                .buttonStyle(.borderless)
            }
            Form {
                TextField(text: $title, prompt: Text("")) { }
                    .font(.body)
                    .focused($focusedField, equals: .title)
                    .textFieldStyle(.plain)
                TextField(text: $note, prompt: Text("Notes")) { }
                    .font(.subheadline)
                    .focused($focusedField, equals: .notes)
                    .textFieldStyle(.plain)
                Toggle(isOn: $isReminding) {
                    DatePicker(selection: $date,
                               in: Date.now...Date.distantFuture,
                               displayedComponents: [.date, .hourAndMinute]) {
                        Text("Remind on")
                    }
                    .disabled(!isReminding)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .task {
            if let reminder {
                note = reminder.note
                isReminding = reminder.reminder
                date = reminder.reminderDate
                title = reminder.title
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .title
            }
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if oldValue == .title, title.isEmpty {
                title = "New Reminder"
            }
        }
        .onChange(of: date) { oldValue, newValue in
            if oldValue != newValue, isDateChanged == false {
                isDateChanged = true
            }
        }
        .onChange(of: isTappingOutside) { oldValue, newValue in
            if newValue == true {
                if !title.isEmpty {
                    addOrUpdateReminder()
                }
                isShowingAdd = false
                isTappingOutside = false
            }
        }
        .onSubmit {
            addOrUpdateReminder()
            isShowingAdd = false
            isTappingOutside = false
        }
    }
    
    private func addOrUpdateReminder() {
        if title.isEmpty {
            title = "New Reminder"
        }
        var item: Reminder
        if let reminder {
            reminder.note = note
            reminder.reminder = isDateChanged ? isReminding : false
            reminder.reminderDate = date
            reminder.title = title
            item = reminder
        } else {
            item = Reminder(note: note,
                            reminder: isDateChanged ? isReminding : false,
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
    }
}

#Preview {
    NewReminder(isShowingAdd: Binding(projectedValue: .constant(true)), isEditing: false)
}
