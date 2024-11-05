//
//  NewCounterView.swift
//  Counter
//
//  Created by Leonardo Genero on 01/10/24.
//

import SwiftUI
import Foundation

// The page in which a new counter will be created setting its name, step size, and starting number
struct NewCounterView: View {
    // A binding to pass the counters array from the main view
    @Binding var counters: [Counter]
    // A state variable to manage the counter's name 
    @State private var name: String = ""
    // A state variable to manage the starting number for the counter 
    @State private var startNumber: String = ""
    // A state variable to manage the step size for the counter
    @State private var stepSize: String = ""
    // Environment variable to manage the presentation state of the view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                // Input field for the counter name
                TextField("Counter Name", text: $name)
                // Input field for the starting number, with number pad keyboard
                TextField("Starting Number", text: $startNumber)
                    .keyboardType(.numberPad) // Only numeric keyboard
                // Input field for the step size
                TextField("Step Size", text: $stepSize)
                    .keyboardType(.numberPad)
                // Button to create a new counter
                Button(action: createCounter) {
                    Text("Create Counter")
                        .font(.headline)
                }
            }
            .navigationTitle("New Counter")
        }
    }
    
    // Gives the counter a default name if user doesn't input one (smallest available "New Counter #N")
    private func getDefaultCounterName() -> String {

        // Collect all "N"s in "New Counter " counters name
        let existingNumbers = counters.compactMap { counter in // `.compactMap` loops over every and skips and ignores any nil values leaving only the ones of interest
            if counter.name.hasPrefix("New Counter ") {
                return Int(counter.name.replacingOccurrences(of: "New Counter ", with: "")) // `.replacingOccurrences` replaces "New Counter " with "" leaving us only the integer that gets transformed in `Int``
            }
            return nil
        }

        // Give the new counter the smalles integer possible
        var n = 1
        while existingNumbers.contains(n) {
            n += 1
        }
        return "New Counter \(n)"
    }

    // Creates a new counter and adds it to the counters array
    private func createCounter() {
        let startNumber = Int(startNumber) ?? 0 // Default is 0
        let stepSize = Int(stepSize) ?? 1 // Default is 1
        let name = name.isEmpty ? getDefaultCounterName() : name // Default is "New counter #N"
        let newCounter = Counter(name: name, count: startNumber, stepSize: stepSize) // Assign all the values to the new counter
        counters.append(newCounter)
        saveCounters()
        presentationMode.wrappedValue.dismiss()
    }
    
    // Save created counter to UserDefaults - Help by ChatGPT
    private func saveCounters() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(counters) {
            UserDefaults.standard.set(encoded, forKey: "counters")
        }
    }
}
