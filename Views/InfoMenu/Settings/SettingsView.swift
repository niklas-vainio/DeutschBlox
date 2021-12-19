//
//  SettingsView.swift
//  GermanLearning
//
//  Created by Niklas on 02/08/2021.
//  A view with all of the app settings
//  Accessed from the info menu by pressing the settings button

import SwiftUI

struct SettingsView: View {
    
    // State to determine showing alert
    @State var showingAlert: Bool = false
    
    // Store managed object context, and fetch request to SRS data
    @Environment(\.managedObjectContext) var context
    
    // Observed object variable for the shared instance of aggregate data
    @ObservedObject var aggregateData = AggregateData.shared
    
    // Fetch request objects to get SRS data and history data
    @FetchRequest(
        entity: SRSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SRSData.nextShowing, ascending: true)]
    ) var srsElements: FetchedResults<SRSData>
    
    @FetchRequest(
        entity: DayActivityData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayActivityData.date, ascending: true)]
    ) var historyData: FetchedResults<DayActivityData>
    
    
    // Stores whether text to speech and sound effects are enabled
    @AppStorage("ttsEnabled") var ttsEnabled: Bool = true
    @AppStorage("sfxEnabled") var sfxEnabled: Bool = true
    
    var body: some View {
        VStack {
            
            // Toggle for text to speech
            Toggle(isOn: $ttsEnabled, label: {
                Image(systemName: ttsEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                    .font(.title2)
                Text("Enable Text to Speech")
                    .font(.title2)
                    .fontWeight(.semibold)
            })
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            
            // Toggle for sound effects
            Toggle(isOn: $sfxEnabled, label: {
                Image(systemName: sfxEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                    .font(.title2)
                Text("Enable Sound Effects")
                    .font(.title2)
                    .fontWeight(.semibold)
            })
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            
            Spacer()
            
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
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .navigationTitle("Settings")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
