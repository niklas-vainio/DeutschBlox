//
//  MainVocabView.swift
//  GermanLearning
//
//  Created by Niklas on 19/07/2021.
//  This file defins the main view that shows users words, and swaps between german and english

import SwiftUI
import AVFoundation

struct MainVocabView: View {
    // Variables to control state of view
    @State private var vocabIndex: Int = 0
    @State var showEnglish: Bool = false
    @State var showVocab: Bool = true
    @State var newWord: Bool = true
    
    // Stores whether it is the first appearance of the app session
    @State var firstAppearance: Bool = true
    
    // Environment parameter for managed object context
    @Environment(\.managedObjectContext) var context
    
    // Obvserved object link to shared aggregate data
    @ObservedObject var aggregateData = AggregateData.shared
    
    // Fetch request variable to get all SRS data and history data
    @FetchRequest(
        entity: SRSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SRSData.nextShowing, ascending: true)]
    ) var srsElements: FetchedResults<SRSData>
    
    @FetchRequest(
        entity: DayActivityData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayActivityData.date, ascending: true)]
    ) var historyData: FetchedResults<DayActivityData>
    
    // Stores whether text to speech and sound effects are enabled
    @AppStorage("sfxEnabled") var sfxEnabled: Bool = true
    
    // Store a voice and a synthesizer for TTS
    let voice = AVSpeechSynthesisVoice(language: "de-DE")
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        // Buttons and UI
        VStack {
            Spacer()
            
            // New word text if showing new word, and showing vocab in general
            if (newWord && showVocab) {
                Text("New Word!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 10.0)
                    .background(Color.purple)
                    .cornerRadius(15)
                    .padding(.bottom, 30.0)
                    .transition(.topEdgeWithFade)
            }
            
            // Vocab entry is showing
            if (showVocab) {
                VocabEntryView(vocabEntry: vocabData[vocabIndex],
                               showEnglish: $showEnglish)
                    .transition(.slide)
            }
            
            Spacer()
            Spacer()

            // Button interface at bottom, with buttons depending on view state
            if (newWord) {
                NewWordContinueButton {
                    // If it doesn't already exist, make an SRSData object for the new word
                    if getSRSData(for: vocabIndex) == nil {
                        makeSRSData(for: vocabData[vocabIndex].id)
                    }
                    
                    // Add one to today's data for new words seen and total words
                    let todayData = getCurrentActivityData()
                    todayData.newWordsSeen += 1
                    todayData.wordsSeen += 1
                    PersistenceController.shared.save()
                    
                    // Show next word
                    showNextWord()
                }
                .transition(.slide)
                .disabled(!showVocab)
                
            } else if (showEnglish) {
                UnderstandingButtons { buttonType in
                    
                    // For safety, make SRS data for the current word if it doesn't exist
                    if getSRSData(for: vocabIndex) == nil {
                        makeSRSData(for: vocabData[vocabIndex].id)
                    }
                    
                    // Add one to today's data for words seen
                    let todayData = getCurrentActivityData()
                    todayData.wordsSeen += 1
                    
                    // Add one to the corresponding count for current word, day and aggregate data
                    let vocabSRSData = getSRSData(for: vocabIndex)!
                    
                    switch buttonType {
                    case .tick:
                        vocabSRSData.timesRight += 1
                        aggregateData.timesRight += 1
                        todayData.numRight += 1
                    case .questionMark:
                        vocabSRSData.timesMaybe += 1
                        aggregateData.timesMaybe += 1
                        todayData.numMaybe += 1
                    case .cross:
                        vocabSRSData.timesWrong += 1
                        aggregateData.timesWrong += 1
                        todayData.numWrong += 1
                    }
                    
                    // Get next showing time and ease factor from Space Repetition Manager
                    let result = SpaceRepetitionManager.getNextnterval(for: vocabSRSData, after: buttonType)
                    vocabSRSData.lastInterval = result.nextInterval
                    vocabSRSData.easeFactor = result.nextEaseFactor
                    vocabSRSData.nextShowing = Date(timeIntervalSinceNow: result.nextInterval)
                    
                    // Save persistent data
                    PersistenceController.shared.save()
                    
                    // Show next word
                    showNextWord()
                }
                .transition(.slide)
                .disabled(!showVocab)
                
            } else {
                ShowEnglishButton() {
                    // Button pressed -> set showEnglish to true and play sound
                    // audioPlayer.play()
                    
                    withAnimation { showEnglish = true }
                }
                .transition(.slide)
                .disabled(!showVocab)
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            // If first load, get next word and set states accordingly
            if firstAppearance {
                vocabIndex = getNextVocabIndex()
                showVocab = true
                
                if getSRSData(for: vocabIndex) == nil {
                    // New word
                    newWord = true
                    showEnglish = true
                } else {
                    // Word already seen
                    newWord = false
                    showEnglish = false
                }
                
                // Reset flag
                firstAppearance = false
            }
            
            // Play text to speech if enabled
            if sfxEnabled {
                let utterance = AVSpeechUtterance(string: vocabData[vocabIndex].article + " " + vocabData[vocabIndex].german.fullWord)
                utterance.voice = voice
                synthesizer.speak(utterance)
            }
            
        })
    }
    
    // Function to show the next vocab word
    func showNextWord() {
        // Hide english and current vocab entry
        withAnimation {
            showEnglish = false
            showVocab = false
        }
        
        let delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 0.5))
        let soundDelay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 0.8))
        
        // Bring back word after half a second
        RunLoop.main.schedule(after: delay) {
            // Get the next word
            vocabIndex = getNextVocabIndex()
            
            // If new word, show english and new word button
            if getSRSData(for: vocabIndex) == nil {
                withAnimation {
                    newWord = true
                    showEnglish = true
                }
            } else {
                // Othwerise, set new word to false
                withAnimation { newWord = false }
            }
            
            // Show vocab entry
            withAnimation {
                showVocab = true
            }
        }
        
        // If enabled, play sound after one second
        if sfxEnabled {
            RunLoop.main.schedule(after: soundDelay) {
                // Say the word with text to speech
                let utterance = AVSpeechUtterance(string: vocabData[vocabIndex].article + " " + vocabData[vocabIndex].german.fullWord)
                utterance.voice = voice
                synthesizer.speak(utterance)
            }
        }
        
    }
    
    // Function to get the next vocab entry to show
    func getNextVocabIndex() -> Int {
        // Get first entry in SRS Data which is due to be reviewed
        let nextWordSRS = srsElements.first(where: {$0.nextShowing! <= Date(timeIntervalSinceNow: 0.0)})
        
        // If there is a word to be reviewed, 95% of the time...
        if (nextWordSRS != nil) && (Double.random(in: 0...1) < 0.95) {
            // Show the word to be reviwed
            return Int(nextWordSRS!.vocabId)
        } else {
            // Otherwise show a new word
            return getIndexOfFirstNewWord()
        }
    }
    
    func getIndexOfFirstNewWord() -> Int {
        // Get the index of the first word which has no SRS data
        let firstUnseenIndex = vocabData.firstIndex(where: { entry in
            srsElements.first(where: {srs in Int(srs.vocabId) == entry.id}) == nil
        })
        
        // Return it, or show word with earliest nest showing time if it is nil (all words seen)
        return firstUnseenIndex ?? Int(srsElements[0].vocabId)
    }
    
    // Function to make a new SRSData object for a vocab index
    func makeSRSData(for id: Int) {
        let newData = SRSData(context: context)
        newData.uuid = UUID()
        newData.vocabId = Int64(id)
        newData.lastInterval = 600.0 * Double.random(in: 0.9...1.1) // Random first delay of roughly 10 minutes
        newData.nextShowing = Date(timeIntervalSinceNow: newData.lastInterval)
        
        PersistenceController.shared.save()
    }
    
    // Function to get the SRSData object corresponding to the current vocab index
    func getSRSData(for id: Int) -> SRSData? {
        // Return first element where vocabId is the same as the given id (optional)
        return srsElements.first(
            where: {$0.vocabId == Int64(id)}
        )
    }
    
    // Function to get current activity data, or make one if it doesn't exist
    func getCurrentActivityData() -> DayActivityData {
        if let currentData = historyData.first(where: { Calendar.current.isDateInToday($0.date!) }) {
            return currentData
        } else {
            let newData = DayActivityData(context: context)
            newData.uuid = UUID()
            // Set date to middle of day today
            newData.date = Calendar.current.startOfDay(for: Date()).advanced(by: 86400 / 2)
            
            PersistenceController.shared.save()
            
            return newData
        }
        
    }
}

struct MainVocabView_Previews: PreviewProvider {
    static var previews: some View {
        MainVocabView()
    }
}
