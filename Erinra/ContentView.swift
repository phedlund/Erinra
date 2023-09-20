//
//  ContentView.swift
//  Erinra
//
//  Created by Peter Hedlund on 8/31/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var reminders: [Reminder]
    
    @State private var isShowingAdd = false
    @State private var reminderState = ReminderState()
    @State private var launchAtLogin = LaunchAtLogin()

    var body: some View {
        VStack {
            HStack {
                Menu {
                    Button {
                        NSApplication.shared.orderFrontStandardAboutPanel()
                    } label: {
                        Text("About...")
                    }
                    Divider()
                    Toggle(isOn: $launchAtLogin.isEnabled) {
                        Text("Launch At Login")
                    }
//                    Button {
//                        //
//                    } label: {
//                        Text("Settings...")
//                    }
//                    .keyboardShortcut(KeyEquivalent(","), modifiers: .command)
                    Divider()
                    Button {
                        NSApplication.shared.terminate(self)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut(KeyEquivalent("q"), modifiers: .command)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                Spacer()
                Text("Erinra")
                    .font(.headline)
                Spacer()
                Button {
                    reminderState.currentReminder = nil
                    isShowingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .focusable(false)
            .buttonStyle(.borderless)
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 4, trailing: 12))
            List(reminders, id: \.persistentModelID) { reminder in
                ReminderListItem(reminder: reminder, isShowingAdd: $isShowingAdd)
                    .environment(reminderState)
                    .padding(.vertical, 4)
            }
            .background(Color(nsColor: .controlBackgroundColor))
            if isShowingAdd {
                NewReminder(reminder: reminderState.currentReminder, isShowingAdd: $isShowingAdd)
                    .modelContext(modelContext)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .frame(width: 400, height: 120, alignment: .leading)
            } else {
                EmptyView()
            }
            Spacer()
        }
        .padding(0)
        .frame(width: 400, height: 400, alignment: .center)
        .overlay {
            if reminders.isEmpty {
                ContentUnavailableView {
                    Text("No reminders")
                } description: {
                    //
                } actions: {
                    //
                }
            }
        }
        .task {
            NotificationManager.shared.requestPermission(onDeny: {
                //
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Reminder.self, inMemory: true)
}
