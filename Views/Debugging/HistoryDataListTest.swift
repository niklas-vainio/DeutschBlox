//
//  HistoryDataListTest.swift
//  GermanLearning
//
//  Created by Niklas on 29/07/2021.
//  This file is for debugging purposes and should show all history data in a list

import SwiftUI

struct HistoryDataListTest: View {
    // Take in managed object context as an environment parameter
    @Environment(\.managedObjectContext) var context
    
    // All day activity items as a fetch request
    @FetchRequest(
        entity: DayActivityData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayActivityData.date, ascending: true)]
    ) var historyData: FetchedResults<DayActivityData>
    
    // Static date formatter property
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            // If empty show text
            if historyData.isEmpty {
                Text("No History Data Yet!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            } else {
                // Show all history in a list
                List {
                    ForEach(historyData, id: \.uuid) { element in
                        // Show data and other counts
                        HStack {
                            // Date
                            if element.date != nil {
                                Text("\(element.date!, formatter: Self.dateFormatter)")
                                    .fontWeight(.semibold)
                            } else {
                                Text("Unknown date")
                                    .fontWeight(.semibold)
                            }
                            
                            // Words and new words
                            VStack {
                                Text("\(element.wordsSeen) words")
                                Text("(\(element.newWordsSeen) new)")
                            }
                            
                            // Num X ? tick
                            VStack {
                                Text("X - \(element.numWrong)")
                                Text("? - \(element.numMaybe)")
                                Text("✓ - \(element.numRight)")
                            }
                            
                            
                        }
                    }
                    // Call function when items are deleted
                    .onDelete(perform: { indexSet in
                        removeItems(at: indexSet)
                        
                    })
                }
                .listStyle(DefaultListStyle())
                .navigationTitle("History")
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
            let itemToDelete = historyData[index]
            PersistenceController.shared.delete(object: itemToDelete)
        }
    }
    
    func deleteAllEntries() {
        // Remove all history data
        historyData.forEach { element in
            PersistenceController.shared.delete(object: element)
        }
    }
}

struct HistoryDataListTest_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDataListTest()
    }
}
