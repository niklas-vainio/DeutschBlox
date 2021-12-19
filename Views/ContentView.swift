//
//  ContentView.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  The primary view for the app
//  Simply shows main menu inside a navigation view

import SwiftUI

struct ContentView: View {
    
    // Environment property which stores the managed object context
    @Environment(\.managedObjectContext) var context
        
    var body: some View {
        MainMenuView()
            .environment(\.managedObjectContext, context)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
