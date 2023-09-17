//
//  Item.swift
//  Erinra
//
//  Created by Peter Hedlund on 8/31/23.
//

import Foundation
import SwiftData

@Model
final class Reminder: Codable {
    enum CodingKeys: CodingKey {
        case uuid
        case note
        case reminder
        case reminderDate
        case title
    }

    @Attribute(.unique) var uuid: UUID
    var note: String
    var reminder: Bool
    var reminderDate: Date
    var title: String

    init(note: String, reminder: Bool, reminderDate: Date, title: String) {
        self.uuid = UUID()
        self.note = note
        self.reminder = reminder
        self.reminderDate = reminderDate
        self.title = title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(UUID.self, forKey: .uuid)
        self.note = try container.decode(String.self, forKey: .note)
        self.reminder = try container.decode(Bool.self, forKey: .reminder)
        self.reminderDate = try container.decode(Date.self, forKey: .reminderDate)
        self.title = try container.decode(String.self, forKey: .title)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(note, forKey: .note)
        try container.encode(reminder, forKey: .reminder)
        try container.encode(reminderDate, forKey: .reminderDate)
        try container.encode(title, forKey: .title)
    }
    
}
