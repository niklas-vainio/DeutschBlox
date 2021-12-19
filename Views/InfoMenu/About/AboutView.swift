//
//  AboutView.swift
//  GermanLearning
//
//  Created by Niklas on 02/08/2021.
//  Shows information about how to use the app
//  Launched by pressing the about button on the info screen

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            ScrollView{
                VStack(alignment: .leading) {
                    
                    // Main title
                    Text("""
                Welcome to DeutschBlox, a fun language learning app by Niklas Vainio!
                """)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.bottom, 20)
                    
                    // What is this app section
                    Text("What is this app?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("""
DeutschBlox is a German-learning app designed to make absorbing new vocabulary easy and fun. This app uses several language-learning principles to enhance your experience - words are broken down into brightly-coloured parts, which builds connections to previously seen words, and exploits your brain’s natural synesthesia, allowing you to associate words with unique patterns of colours. DeutschBlox also makes use of spaced repetition - each word is shown at increasing intervals, which maximises your brain’s ability to absorb new information,
                        
Unlike other language-learning apps, using DeutschBlox is an effortless experience! There are no accounts to set up, decks to download or settings to configure. All you have to do is start learning, and the app takes care of the rest!
""")
                        .padding(.bottom, 20)
                    
                    
                    // How to use section
                    
                    Text("How do I use it?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("""
The app’s main view will show you a mixture of new and already-seen words. When a word appears that you’ve seen before, a blue “Show English” button will appear at the bottom of the screen. Try to remember what the word means in English, and then press the button to check your  understanding.
                        
Once you press the “Show English” button, the word’s English translation and example sentences will appear. Three buttons will appear at the bottom of the screen, and you should press the one corresponding to how well you understood the word:
""")
                        .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                        Text("Remembered the meaning of the word easily")
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "questionmark.diamond.fill")
                            .foregroundColor(.yellow)
                            .font(.title)
                        Text("Remembered the meaning of the world after struggling a lot, or remember the vague sense of the word, but not its exact meaning")
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "xmark.square.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text("Did not remember the word at all, or remembered the wrong meaning")
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 20)

                    // Credits
                    Text("Credits")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("""
The vocabulary data was originally sourced from the "5000 German words sorted by frequency" deck on Anki Web (Available at: https://ankiweb.net/shared/info/107258650)
                
Word decompounding and many significant adaptations have been performed.
                
This app was programmed and developed by Niklas Vainio in July-August 2021.
""")
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
