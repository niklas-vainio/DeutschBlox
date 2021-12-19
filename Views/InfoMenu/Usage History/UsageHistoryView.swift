//
//  UsageHistoryView.swift
//  GermanLearning
//
//  Created by Niklas on 01/08/2021.
//  This file defines a view for the usage history page
//  Accessed by pressing the "usage history" button on the info screen

import SwiftUI

struct UsageHistoryView: View {
    // Aggregate data shared object
    @ObservedObject var aggregateData = AggregateData.shared
    
    // Store managed object context and a fetch request to get history data
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: DayActivityData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayActivityData.date, ascending: true)]
    ) var historyData: FetchedResults<DayActivityData>
    
    
    var body: some View {
        VStack {
            
            // Words seen today
            HStack {
                Text("\(getTodayData()?.wordsSeen ?? 0)")
                    .foregroundColor(.blue)
                    .font(.title)
                    .fontWeight(.bold)
                Text("total words today")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            // New words today
            HStack {
                Text("\(getTodayData()?.newWordsSeen ?? 0)")
                    .foregroundColor(.purple)
                    .font(.title)
                    .fontWeight(.bold)
                Text("new words today")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            
            // Streak info
            HStack {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.title)
                    Text("\(getStreakLength())")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Day Streak")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding(.all, 10.0)
                .background(Color.pink)
                .cornerRadius(20)
                
                Spacer()
            }
            .padding(.bottom, 30.0)
            
            // If more than one days studied, show graphs
            if historyData.count > 1 {
                
                // Words seen graph
                Text("Words Studied")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                HistoryLineGraph(
                    yValues: getWordDataList(newWords: false),
                    lineColor: .blue,
                    startDate: aggregateData.dateStarted
                )
                .padding(.vertical, 10.0)
                
                // New words seen graph
                Text("New Words Studied")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                HistoryLineGraph(
                    yValues: getWordDataList(newWords: true),
                    lineColor: .purple,
                    startDate: aggregateData.dateStarted
                )
                .padding(.vertical, 10.0)
            } else {
                // Othwerise, show text saying not enough days studied
                Spacer()
                
                Text("Come back later!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10.0)
                
                Text("More information will appear on this page once you study for a few days! Come back soon!")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20.0)
                
            }
            
            Spacer()
            
            // Button to see full data
            NavigationLink(destination: ZStack {
                // Background image
                Image("notebook")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                
                HistoryDataListView()
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                    Text("View full data")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                .foregroundColor(.white)
                .padding(.vertical, 20.0)
                .padding(.horizontal, 10.0)
                .background(Color.blue)
                .cornerRadius(10.0)
                .padding(.bottom, 20.0)
            }
        }
        .padding(.horizontal, 20.0)
        .navigationTitle("Usage History")
    }
    
    func getTodayData() -> DayActivityData? {
        // Returns the DayActivityData object for today or nil if it doesnt exist
        return historyData.first(where: {
            Calendar.current.isDateInToday($0.date!)
        })
    }
    
    func getStreakLength() -> Int {
        // Returns the streak, number of days studied until the current day
        let today = Calendar.current.startOfDay(for: Date()).advanced(by: 86400 / 2)
        
        // Loop backwards from today until a day with no data is found
        var streakCount = 1
        var dateIterator = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        while true {
            // Break if no data found
            if historyData.first(where: { Calendar.current.isDate($0.date!, inSameDayAs: dateIterator) }) == nil {
                return streakCount
            }
            
            // Otherwise increment count and check previous day
            streakCount += 1
            dateIterator = Calendar.current.date(byAdding: .day, value: -1, to: dateIterator)!
        }
    }
    
    func getWordDataList(newWords: Bool) -> [Int] {
        // Returns a list of int values for the number of words  or new words studied each day
        var output: [Int] = []
        
        var dateIterator = aggregateData.dateStarted
        let today = Calendar.current.startOfDay(for: Date()).advanced(by: 86400 / 2)
        
        while true {
            // Get the dayActivityData object for this day
            let activityData = historyData.first(where: {
                Calendar.current.isDate(dateIterator, inSameDayAs: $0.date!)
            })
            
            // Add its wordsSeen or newWordsSeen to the output array depending on argument
            if newWords {
                output.append(Int(activityData?.newWordsSeen ?? 0))
            } else {
                output.append(Int(activityData?.wordsSeen ?? 0))
            }
            
            
            // If date iterator is in today, break
            if Calendar.current.isDate(dateIterator, inSameDayAs: today) {
                break
            }
            
            // Othwerise, advance dateIterator and repeat
            dateIterator = Calendar.current.date(byAdding: .day, value: 1, to: dateIterator)!
        }
        
        return output
    }
}

struct UsageHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        UsageHistoryView()
    }
}
