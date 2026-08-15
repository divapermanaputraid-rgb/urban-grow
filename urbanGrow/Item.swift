//
//  Item.swift
//  urbanGrow
//
//  Created by MacBook on 16/08/26.
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
