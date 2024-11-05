//
//  CounterStruct.swift
//  Counter
//
//  Created by Leonardo Genero on 01/10/24.
//

import Foundation

// Counter object struct, with: id, name, count, stepSize, creationDate, and pinned variables
struct Counter: Identifiable, Codable {
    var id = UUID()
    var name: String
    var count: Int {
        didSet {
            saveCount()
        }
    }
    var stepSize: Int
    var creationDate: Date
    var pinned: Bool = false

    // Initialize variables
    init(name: String, count: Int, stepSize: Int = 1) {
        self.name = name
        self.count = count
        self.stepSize = stepSize
        self.creationDate = Date()

        // Check if there is already a saved count for this counter
        let savedCount = Counter.loadCount(for: id)
        // Load the count from UserDefaults if it exists, otherwise use the provided count
        self.count = savedCount != 0 ? savedCount: count
    }

    // Save the count to UserDefaults
    func saveCount() {
        UserDefaults.standard.set(count, forKey: "\(id.uuidString)_count")
    }

    // Load the count from UserDefaults - Function is `static`` since you do not need to instantiate a struct, you just have to look at the UUIDs
    static func loadCount(for id: UUID) -> Int {
        return UserDefaults.standard.integer(forKey: "\(id.uuidString)_count")
    }
}
