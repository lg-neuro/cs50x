//
//  ContentView.swift
//  Counter
//
//  Created by Leonardo Genero on 01/10/24.
//

import SwiftUI
import Foundation

// The main content view where the list of counters will be displayed
struct ContentView: View {
    // A state variable to keep track and show all the existing counters
    @State private var counters: [Counter] = []
    // A state variable to show the new counter creation view
    @State private var showNewCounterView = false
    
    var body: some View {
        NavigationView {
            ZStack {

                // Set the background color
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)

                VStack {
                    // If there are no counters, show guidelines
                    if counters.isEmpty {
                        Text("To create a new counter tap on the \"+\" icon")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding()
                    } else {
                        List {

                            // Loop through the counters array and create a navigation link for each -- `sortedCounters()` keeps them in temporal order
                            ForEach(sortedCounters()) { counter in
                                NavigationLink(

                                    // Pass the specific counter to `CounterView`
                                    destination: CounterView(counter: binding(for: counter), saveCounters: saveCounters)
                                ) {
                                    HStack {

                                        // Display the counter name
                                        Text(counter.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        // Display pin image, if counter's pinned
                                        if counter.pinned {
                                            Image(systemName: "pin.fill")
                                                .foregroundColor(.yellow)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    }
                                }
                                
                                // Swipe to eliminate action (right-to-left)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteCounter(counter)
                                    } label: {
                                        Label("Eliminate", systemImage: "trash")
                                    }
                                }
                                
                                // Swipe to pin/un-pin action (left-to-right)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        togglePin(counter)
                                    } label: {
                                        Label(counter.pinned ? "Unpin" : "Pin", systemImage: counter.pinned ? "pin.slash" : "pin")
                                    }
                                    .tint(.yellow)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Counters")
            
            // Button to show the NewCounterView to create a new counter
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {

                    // New counter ("+" icon) button to the right
                    Button (action: {
                        showNewCounterView = true
                    }) {
                        ZStack {
                            
                            // "+" button desing
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                }
            }
            
            // Show NewCounterView when the button is pressed
            .sheet(isPresented: $showNewCounterView) {
                NewCounterView(counters: $counters)
            }
                        
            // Load previous counters and save the newly created ones everytime that ContentView is presented
            .onAppear {
                loadCounters()
                saveCounters()
            }
        }
    }
    
    // Pinned counters come first, newer counter come before older ones -- Function returns the sorted counters array
    func sortedCounters() -> [Counter] {
        counters.sorted { counter1, counter2 in

            // Return the pinned counter, if it is the only one
            if counter1.pinned != counter2.pinned {
                return counter1.pinned && !counter2.pinned
            }

            // If both counters are pinned or un-pinned, return the newst one
            return counter1.creationDate > counter2.creationDate
        }
    }
    
    // Function to return a binding for a specific counter
    private func binding(for counter: Counter) -> Binding<Counter> {
        guard let index = counters.firstIndex(where: { $0.id == counter.id }) else {
            fatalError("Counter not found!") // `guard` is used as safeguard in case the id is not found 
        }
        return $counters[index]
    }
    
    // Pin or unpin a specific counter
    func togglePin(_ counter: Counter) {
        if let index = counters.firstIndex(where: {$0.id == counter.id}) {
            counters[index].pinned.toggle()
            saveCounters()
        }
    }
    
    // Delete a specific counter
    func deleteCounter(_ counter: Counter) {
        counters.removeAll { $0.id == counter.id }
        saveCounters()
    }


    // Save created counters to UserDefaults - Help by ChatGPT
    func saveCounters() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(counters) {
            UserDefaults.standard.set(encoded, forKey: "counters")
        }
    }

    // Loads the saved counters from UserDefaults - Help by ChatGPT
    func loadCounters() {
        if let savedData = UserDefaults.standard.data(forKey: "counters") {
            let decoder = JSONDecoder()
            if let decodedCounters = try? decoder.decode([Counter].self, from: savedData) {
                self.counters = decodedCounters
            }
        }
    }
}
