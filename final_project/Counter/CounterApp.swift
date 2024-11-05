//
//  CounterApp.swift
//  Counter
//
//  Created by Leonardo Genero on 01/10/24.
//

import SwiftUI
import Foundation

// Application entry point -- App protocol
@main
struct CounterApp: App {
    var body: some Scene { // Use `some` to express existential types while being flexible on the the exact type when compiling
        WindowGroup {
            // Root view of the app 
            ContentView()
        }
    }
}

