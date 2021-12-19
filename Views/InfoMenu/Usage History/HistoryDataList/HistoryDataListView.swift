//
//  HistoryDataListView.swift
//  GermanLearning
//
//  Created by Niklas on 01/08/2021.
//  Shows all history data in a list
//  Accessed from the main usage history view

import SwiftUI

struct HistoryDataListView: View {
    // Fetch request to get the history data
    @FetchRequest(
        entity: DayActivityData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayActivityData.date, ascending: false)]
    ) var historyData: FetchedResults<DayActivityData>
    
    // Static date formatter property
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    var body: some View {
        // Show the actual list
        VStack {
            if historyData.isEmpty {
                // Show message if history data is empty
                Text("No history data yet!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50.0)
                
                Text("You don't have any history data yet! Come back to this menu once you've studied for a few days!")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20.0)
            } else {
                // Spacer at top to leave a gap
                Spacer()
                
                // List of all day data
                List {
                    ForEach(historyData, id: \.uuid) { element in
                        
                        HStack {
                            
                            if element.date != nil {
                                // Show the date for this entry
                                HStack(spacing: 5.0) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                    
                                    Text("\(element.date!, formatter: Self.dateFormatter)")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
                                
                            } else {
                                // Should never appear, but here to be safe
                                Text("Unknown date!")
                                    .foregroundColor(.red)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            
                            
                            Spacer()
                            
                            VStack {
                                // Number of total words
                                HStack(spacing: 5.0) {
                                    Text("\(element.wordsSeen)")
                                        .foregroundColor(.blue)
                                        .fontWeight(.bold)
                                    Text("total words")
                                        .fontWeight(.semibold)
                                }
                                .font(.title3)
                                
                                // Number of new words
                                HStack(spacing: 5.0) {
                                    Text("\(element.newWordsSeen)")
                                        .foregroundColor(.purple)
                                        .fontWeight(.bold)
                                    Text("new words")
                                        .fontWeight(.semibold)
                                }
                                .font(.title3)
                                
                                // Number of ticks, ? and X
                                HStack(spacing: 5.0) {
                                    Image(systemName: "xmark.square.fill")
                                        .foregroundColor(.red)
                                    Text("\(element.numWrong)")
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "questionmark.diamond.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(element.numMaybe)")
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("\(element.numRight)")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        
                        
                    }
                }
                
            }
        }
        .navigationTitle("History Data")
    }
}
