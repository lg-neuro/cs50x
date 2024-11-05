//
//  CounterView.swift
//  Counter
//
//  Created by Leonardo Genero on 01/10/24.
//

import SwiftUI
import Foundation
import UIKit

struct CounterView: View {
    // A binding to pass the counters array from the main view
    @Binding var counter: Counter
    // Variable to allow the counter data to be saved
    var saveCounters: () -> Void
    // A state variable to show the settings view
    @State private var showSettings = false
    
    var body: some View {
        VStack {
            // Display the counter name
            Text(counter.name)
                .font(.title)
                .padding()
            
            Spacer(minLength: UIScreen.main.bounds.width * 0.35)
            
            // Display the current counter value
            Text("\(counter.count)")
                .font(.custom("Menlo", size: 150))
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.85, maxHeight: .infinity, alignment: .center)
            
            Spacer(minLength: UIScreen.main.bounds.width * 0.50)
            
            // Display the date and time when the counter was created
            Text("Created on: \(counter.creationDate, formatter: dateFormatter)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .contentShape(Rectangle()) // Whole area detects taps and drags
        
        // Detect tap gestures to increment the counter
        .onTapGesture {
            counter.count += counter.stepSize
            hapticFeedback()
            saveCount()
        }
        
        // Detect swipe gestures to decrement the counter
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.width < 0 {
                        counter.count -= counter.stepSize
                        hapticFeedback()
                        saveCount()
                    }
                }
        )
        .navigationBarTitleDisplayMode(.inline)
        
        // Add a settings button in the top right corner
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSettings.toggle()
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            CounterSettingsView(counter: $counter, saveCounters: saveCounters)
        }
    }
    
    func saveCount() {
        UserDefaults.standard.set(counter.count, forKey: "\(counter.id.uuidString)_count")
        saveCounters()
    }
    
    // Produce a haptic feedback
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
}

// A date formatter for displaying the creation date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

