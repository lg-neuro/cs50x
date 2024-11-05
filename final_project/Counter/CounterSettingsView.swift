//
//  CounterSettingsView.swift
//  Counter
//
//  Created by Leonardo Genero on 10/10/24.
// 

import SwiftUI
import Foundation

struct CounterSettingsView: View {
    // A binding to pass the counters array from the main view
    @Binding var counter: Counter
    // Variable to allow the counter data to be saved
    var saveCounters: () -> Void
    // A state variable to manage the counter's name
    @State private var name: String = ""
    // A state variable to manage the step size 
    @State private var stepSize: String = ""
    // A state variable to manage the amount to add to the counter 
    @State private var addValue: String = ""
    // A state variable to manage the starting number for the counter 
    @State private var setCountValue: String = ""
    // Environment variable to manage the presentation state of the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                // Input field for editing the counter name
                TextField("Counter Name", text: $name)
                
                // Input field for editing the step size
                TextField("Step Size", text: $stepSize)
                    .keyboardType(.numberPad)
                
                // Input field for adding a precise number to the current count
                TextField("Add to Current Count", text: $addValue)
                    .keyboardType(.numberPad)
                
                // Input field for setting the count to an exact value
                TextField("Set Current Count To", text: $setCountValue)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Edit Counter")

            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss() // Dismisses the view
                },
                trailing: Button("Save") {
                    saveSettings()
                    presentationMode.wrappedValue.dismiss() // Dismisses the view after saving
                }
            )
        }
        .onAppear {
            name = counter.name
            stepSize = "\(counter.stepSize)"
        }
    }
    
    // Save the new settings
    private func saveSettings() {
        if !name.isEmpty {
            counter.name = name
        }
        
        if let newStepSize = Int(stepSize) {
            counter.stepSize = newStepSize
        }
        
        if let addAmount = Int(addValue) {
            counter.count += addAmount
        }
        
        if let newCountValue = Int(setCountValue) {
            counter.count = newCountValue
        }
        
        saveCounters()
    }
}
