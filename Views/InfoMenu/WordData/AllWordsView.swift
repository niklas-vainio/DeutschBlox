//
//  AllWordsView.swift
//  GermanLearning
//
//  Created by Niklas on 28/07/2021.
//  Shows a list of all words with various ingo
//  Opened by clicking the all words button in the info screen

import SwiftUI
import CoreData

struct AllWordsView: View {
    // State variable to determine whether showing action sheet
    @State var showingActionSheet: Bool = false
    
    // Store managed object context and fetch request to SRS data
    @Environment(\.managedObjectContext) var context
    
    // Store a sort descriptor as a state property
    @State var sortDescriptor: NSSortDescriptor = NSSortDescriptor(keyPath: \SRSData.vocabId, ascending: true)
    @State var sortDescriptorIndex = 0
    
    var body: some View {
        // List of data for all seen words
        WordListView(sortDescriptor: sortDescriptor)
            .opacity(0.9)
            .navigationTitle("Word List")
            // Button in top right to configure sorting
            .navigationBarItems(
                trailing: Button(
                    action: {
                        showingActionSheet = true
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                            .scaleEffect(1.5)
                            .padding(.trailing, 10.0)
                    })
            )
            // Action sheet to pick sorting type
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Sort by..."),
                    buttons: [
                        .default(Text("Word # (Ascending)" + (sortDescriptorIndex == 0 ? " ✓" : ""))) {
                            sortDescriptor = NSSortDescriptor(keyPath: \SRSData.vocabId, ascending: true)
                            sortDescriptorIndex = 0
                        },
                        .default(Text("Word # (Descending)" + (sortDescriptorIndex == 1 ? " ✓" : ""))) {
                            sortDescriptor = NSSortDescriptor(keyPath: \SRSData.vocabId, ascending: false)
                            sortDescriptorIndex = 1
                        },
                        .default(Text("Next Showing (Earliest First)" + (sortDescriptorIndex == 2 ? " ✓" : ""))) {
                            sortDescriptor = NSSortDescriptor(keyPath: \SRSData.nextShowing, ascending: true)
                            sortDescriptorIndex = 2
                        },
                        .default(Text("Next Showing (Latest First)" + (sortDescriptorIndex == 3 ? " ✓" : ""))) {
                            sortDescriptor = NSSortDescriptor(keyPath: \SRSData.nextShowing, ascending: false)
                            sortDescriptorIndex = 3
                        },
                        .cancel()
                    ]
                )
            }
    }
    
    
}

// Word list struct which takes in a sort descriptor in its initialiser
struct WordListView: View {
    // Empty fetch request and context
    @FetchRequest var srsElements: FetchedResults<SRSData>
    @Environment(\.managedObjectContext) var context
    
    // Custom init mathod taking in an NSSortDescriptor
    init(sortDescriptor: NSSortDescriptor) {
        let request: NSFetchRequest<SRSData> = SRSData.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        _srsElements = FetchRequest<SRSData>(fetchRequest: request)
    }
    
    
    // Main view returned by this struct
    var body: some View {
        VStack {
            if srsElements.isEmpty {
                // No SRS data -> show message
                Text("No words yet!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50.0)
                
                Text("You haven't learnt any words yet! Come back to this menu once you've seen some words!")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20.0)
                
            } else {
                // Spacer to leave small gap at top
                Spacer()
                
                // Show list of WordListElementViews
                List {
                    ForEach(srsElements, id: \.uuid) { srs in
                        
                        // Word list element with a navigation link to the vocab entry
                        NavigationLink(
                            destination:
                                ZStack {
                                    BackgroundImage()
                                    
                                    VocabEntryView(
                                        vocabEntry: vocabData[Int(srs.vocabId)],
                                        showEnglish: Binding.constant(true)
                                    )
                                    .animation(nil)
                                }
                        ) {
                            WordListElementView(srs: srs)
                        }
                        
                    }
                }
                
                
            }
        }
        
        
        
    }
}

struct AllWordsView_Previews: PreviewProvider {
    static var previews: some View {
        AllWordsView()
    }
}
