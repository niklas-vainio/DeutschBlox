//
//  MainAppView.swift
//  GermanLearning
//
//  Created by Niklas on 02/08/2021.
//  This view is the view for the main app, which is the main vocab view with some navigation buttons
//  Accessed by start button on the main menu view

import SwiftUI

struct MainAppView: View {
    // Environment property which stores the managed object context
    @Environment(\.managedObjectContext) var context
        
    var body: some View {
        ZStack {
            // Background image and main vocab view
            BackgroundImage()
            MainVocabView()
                .environment(\.managedObjectContext, context)
        }
        .toolbar {
            // Button to load info menu on right
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: ZStack {
                        BackgroundImage()
                        InfoMenuMain()
                            .environment(\.managedObjectContext, context)
                    },
                    label: {
                        Image(systemName: "chart.bar.xaxis")
                    })
            }
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
