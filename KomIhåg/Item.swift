//
//  Item.swift
//  KomIhåg
//
//  Created by Peter Hedlund on 8/31/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
