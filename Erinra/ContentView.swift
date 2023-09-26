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
    
    @AppStorage("TappingOutside") var isTappingOutside: Bool = false

    @Query private var reminders: [Reminder]
    
    @State private var isShowingAdd = false

    @State private var reminderState = ReminderState()
    @State private var launchAtLogin = LaunchAtLogin()
    
    @Namespace var bottomID

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
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ForEach(reminders, id: \.persistentModelID) { reminder in
                                ReminderListItem(reminder: reminder, isShowingAdd: $isShowingAdd)
                                    .environment(reminderState)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 18)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        print("I tapped inside")
                                    }
                                Divider()
                                    .padding(.horizontal)
                            }
                            Group {
                                if isShowingAdd {
                                    NewReminder(reminder: reminderState.currentReminder, isShowingAdd: $isShowingAdd, isEditing: false)
                                        .modelContext(modelContext)
                                        .background(Color(nsColor: .controlBackgroundColor))
                                        .contentShape(Rectangle())
                                } else {
                                    EmptyView()
                                }
                            }
                            .id(bottomID)
                        }
                        .frame(minWidth: geometry.size.width, minHeight: geometry.size.height, alignment: .top)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("I tapped")
                            isTappingOutside.toggle()
                        }
                    }
                    .background(Color(nsColor: .controlBackgroundColor))
                    .onChange(of: isShowingAdd) { _, newValue in
                        if newValue {
                            proxy.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                }
            }
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
