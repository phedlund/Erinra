//
//  ReminderListItem.swift
//  Erinra
//
//  Created by Peter Hedlund on 9/4/23.
//

import SwiftUI

struct ReminderListItem: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openWindow) var openWindow
    @Environment(ReminderState.self) private var reminderState

    @State var reminder: Reminder
    @Binding var isShowingAdd: Bool

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack(alignment: .top) {
            Button {
                do {
                    modelContext.delete(reminder)
                    try modelContext.save()
                } catch {
                    print(error)
                }
            } label: {
                Image(systemName: "circle")
            }
            .buttonStyle(.borderless)
            LabeledContent {
                Text("")
            } label: {
                Text(reminder.title)
                if reminder.note.count > 0 {
                    Text(reminder.note)
                }
                if reminder.reminder {
                    Text(dateFormatter.string(from: reminder.reminderDate))
                }
            }
            Spacer()
            Button {
                reminderState.currentReminder = reminder
                isShowingAdd = true
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    ReminderListItem(reminder: Reminder(note: "Some more information", reminder: false, reminderDate: Date(), title: "My Preview Reminder"), isShowingAdd: Binding(projectedValue: .constant(true)))
}
