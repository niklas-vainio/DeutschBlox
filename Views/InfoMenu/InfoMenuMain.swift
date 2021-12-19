//
//  InfoMenuMain.swift
//  GermanLearning
//
//  Created by Niklas on 28/07/2021.
//  This is the primary view for the info menu, accessed by navigation

import SwiftUI

struct InfoMenuMain: View {
    
    // State to determine showing alert
    @State var showingAlert: Bool = false
    
    // Store managed object context, and fetch request to SRS data
    @Environment(\.managedObjectContext) var context
    
    // Observed object variable for the shared instance of aggregate data
    @ObservedObject var aggregateData = AggregateData.shared
    
    // Fetch request object to get SRS data and history data
    @FetchRequest(
        entity: SRSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SRSData.nextShowing, ascending: true)]
    ) var srsElements: FetchedResults<SRSData>
    
    @FetchRequest(
        entity: DayActivityData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayActivityData.date, ascending: true)]
    ) var historyData: FetchedResults<DayActivityData>
    
    // Stores whether sound effects are enabled
    @AppStorage("sfxEnabled") var sfxEnabled: Bool = true
    
    // Static date formatter property
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20.0) {
            HStack {
                // Words Studied Text
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(srsElements.count)")
                            .foregroundColor(.blue)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("of \(vocabData.count)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Text("Words studied")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                // Pie chart
                VocabPieChart(
                    fillLevel: Double(srsElements.count) / Double(vocabData.count)
                )
                .frame(width: 80.0, height: 80.0)
                .padding(.trailing, 20.0)
            }
            
            // Number of X, ? and ticks
            HStack(alignment: .bottom) {
                VStack {
                    Image(systemName: "xmark.square.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 50, weight: .semibold))
                        .frame(width: 50.0, height: 55.0)
                    Text("\(aggregateData.timesWrong)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "questionmark.diamond.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 50, weight: .semibold))
                        .frame(width: 50.0, height: 55.0)
                    
                    Text("\(aggregateData.timesMaybe)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 50, weight: .semibold))
                        .frame(width: 50.0, height: 55.0)
                    Text("\(aggregateData.timesRight)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            HStack {
                // Starting date and number of days studied
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(historyData.count)")
                            .foregroundColor(.blue)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("days studied")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Text("Started on \(aggregateData.dateStarted, formatter: Self.dateFormatter)")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
            
            Spacer()
            
            // All words link
            NavigationLink(destination: ZStack {
                BackgroundImage()
                AllWordsView()
                    .environment(\.managedObjectContext, context)
            }) {
                HStack {
                    Image(systemName: "character.book.closed.fill")
                        .font(.title2)
                    Text("Word List")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                .foregroundColor(.white)
                .padding(.vertical, 20.0)
                .padding(.horizontal, 10.0)
                .background(Color.purple)
                .cornerRadius(10.0)
                .padding(.vertical, -5.0)
            }
            
            // Usage history link
            NavigationLink(destination: ZStack{
                BackgroundImage()
                UsageHistoryView()
                    .environment(\.managedObjectContext, context)
            }) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                    Text("Usage History")
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
                .padding(.vertical, -5.0)
            }
            
            // About link
            NavigationLink(destination: ZStack {
                BackgroundImage()
                AboutView()
            }) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                    Text("About")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                .foregroundColor(.white)
                .padding(.vertical, 20.0)
                .padding(.horizontal, 10.0)
                .background(Color.pink)
                .cornerRadius(10.0)
                .padding(.vertical, -5.0)
            }
            .padding(.bottom, 5.0)
            
            // Toggle for sound effects
            Toggle(isOn: $sfxEnabled, label: {
                Image(systemName: sfxEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                Text("Enable Audio")
                    .fontWeight(.semibold)
            })
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            .padding(.vertical, -5)
            
            // Reset all data button
            Button(action: {showingAlert = true}, label: {
                HStack {
                    Text("Delete All Data")
                        .fontWeight(.bold)
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .padding(.bottom, 5.0)
            })
            .alert(isPresented: $showingAlert, content: {
                Alert(
                    title: Text("Delete All Data?"),
                    message: Text("Are you sure you want to delete all data, including records of words learnt and usage history? (This cannot be undone)"),
                    primaryButton: .cancel(Text("No")),
                    secondaryButton: .destructive(Text("Yes"), action: deleteAllData)
                )
            })
            
        }
        .padding(.horizontal, 20.0)
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // Function to delete all srs, history and aggregate data
    func deleteAllData() {
        srsElements.forEach { element in
            PersistenceController.shared.delete(object: element)
        }
        
        historyData.forEach { element in
            PersistenceController.shared.delete(object: element)
        }
        
        aggregateData.resetAll()
    }
}

struct InfoMenuMain_Previews: PreviewProvider {
    static var previews: some View {
        InfoMenuMain()
    }
}
