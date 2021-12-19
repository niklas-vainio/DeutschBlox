//
//  SRSDataListTest.swift
//  GermanLearning
//
//  Created by Niklas on 22/07/2021.
//  This file is for debugging pusposes, and should show all spaced repetition data in a list

import SwiftUI

struct SRSDataListTest: View {
    // Take in managed object context as an environment parameter
    @Environment(\.managedObjectContext) var context
    
    // All SRS Items as a fetch request
    @FetchRequest(
        entity: SRSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SRSData.nextShowing, ascending: true)]
    ) var srsElements: FetchedResults<SRSData>
    
    // Observed object to get aggregate data
    // @ObservedObject var aggregateData = AggregateData()
    
    // Static date formatter property
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    // Static time formatter property
    static let intervalFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            // If empty show text
            if srsElements.isEmpty {
                Text("No SRS Data Yet!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            } else {
                // Show aggregate data like total words etc.
                Text("Total Words: \(srsElements.count)")
                    .fontWeight(.bold)
                Text("Date Started: ?")
                Text("Days Studied: ?")
                
                // Show all SRS Data in a list
                List {
                    ForEach(srsElements, id: \.uuid) { element in
                        // Show compound word and next showing date for each view
                        HStack {
                            CompoundWordView(
                                compoundWord: vocabData[Int(element.vocabId)].german,
                                article: vocabData[Int(element.vocabId)].article,
                                showDefinitions: Binding.constant(false)
                            )
                            .scaleEffect(0.5)
                            
                            VStack{
                                
                                if element.nextShowing != nil {
                                    Text("Show next: \(element.nextShowing!, formatter: Self.dateFormatter) (\(Self.intervalFormatter.string(from: element.lastInterval)!))")
                                } else {
                                    Text("Unknown showing date!")
                                }
                                Text("Ease factor: \(String(format: "%.2f", element.easeFactor))")
                                
                                Text("X: \(element.timesWrong) ?: \(element.timesMaybe) ✓: \(element.timesRight)")
                            }
                        }
                    }
                    // Call function when items are deleted
                    .onDelete(perform: { indexSet in
                        removeItems(at: indexSet)
                        
                    })
                }
                .listStyle(DefaultListStyle())
                .navigationTitle("SRS Data")
            }
            
            Spacer()
            
            // Button at bottom to delete all SRS data
            Button(action: {
                deleteAllEntries()
            }, label: {
                HStack {
                    Text("Delete all data")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            })
        }
    }
    
    func removeItems(at indices: IndexSet) {
        // Remove items at the incides specified
        for index in indices {
            let itemToDelete = srsElements[index]
            PersistenceController.shared.delete(object: itemToDelete)
        }
    }
    
    func deleteAllEntries() {
        // Remove all SRS entries
        srsElements.forEach { element in
            PersistenceController.shared.delete(object: element)
        }
    }
}

struct SRSDataListTest_Previews: PreviewProvider {
    static var previews: some View {
        SRSDataListTest()
    }
}
