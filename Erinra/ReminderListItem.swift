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
    @State private var isDone = false
    @Binding var isShowingAdd: Bool
    @State private var isShowingEdit = false

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack(alignment: .top) {
            Button {
                withAnimation {
                    isDone.toggle()
                } completion: {
                    do {
                        modelContext.delete(reminder)
                        try modelContext.save()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Image(systemName: isDone ? "circle.inset.filled" : "circle")
            }
            .buttonStyle(.borderless)
            .contentTransition(.symbolEffect(.replace))
            LabeledContent {
                Text("")
            } label: {
                linkText(text: reminder.title)
                if reminder.note.count > 0 {
                    linkText(text: reminder.note)
                }
                if reminder.reminder {
                    Text(dateFormatter.string(from: reminder.reminderDate))
                }
            }
            Spacer()
            Button {
                reminderState.currentReminder = reminder
                isShowingEdit = true
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .buttonStyle(.borderless)
            .popover(isPresented: $isShowingEdit, arrowEdge: .trailing) {
                NewReminder(reminder: reminder, isShowingAdd: $isShowingAdd, isEditing: true)
                    .modelContext(modelContext)
                    .padding()
            }
        }
    }
    
    func linkText(text: String) -> some View {
        var attrString: AttributedString
        if let attrStr = try? AttributedString(markdown: text) {
            attrString = attrStr
        } else {
            attrString = AttributedString(text)
        }
        return Text(attrString)
    }
}

#Preview {
    ReminderListItem(reminder: Reminder(note: "Some more information",
                                        reminder: false,
                                        reminderDate: Date(),
                                        title: "My Preview Reminder"),
                     isShowingAdd: Binding(projectedValue: .constant(true)))
    .environment(ReminderState())
}
