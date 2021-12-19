//
//  AggregateData.swift
//  GermanLearning
//
//  Created by Niklas on 27/07/2021.
//  This file defines a class which holds aggregate data such as total words studied, data studied etc
//  This class is an observable object, and stores persistent data using UserDefaults
//  Exists within a singleton pattern for access from all views

import Foundation
import Combine

class AggregateData: ObservableObject {
    
    // Shared instance for singleton pattern
    static let shared = AggregateData()
    
    // Data properties - all published with didSet closures
    @Published var dateStarted: Date {
        didSet {
            UserDefaults.standard.set(dateStarted, forKey: "dateStarted")
        }
    }

    @Published var daysStudied: Int {
        didSet {
            UserDefaults.standard.set(daysStudied, forKey: "daysStudied")
        }
    }
    
    @Published var timesRight: Int {
        didSet {
            UserDefaults.standard.set(timesRight, forKey: "timesRight")
        }
    }
    
    @Published var timesMaybe: Int {
        didSet {
            UserDefaults.standard.set(timesMaybe, forKey: "timesMaybe")
        }
    }
    
    @Published var timesWrong: Int {
        didSet {
            UserDefaults.standard.set(timesWrong, forKey: "timesWrong")
        }
    }
    
    // Init function which loads all variables from UserDefaults
    init() {
        daysStudied = UserDefaults.standard.object(forKey: "daysStudied") as? Int ?? 0
        dateStarted = UserDefaults.standard.object(forKey: "dateStarted") as? Date ?? Calendar.current.startOfDay(for: Date()).advanced(by: 86400 / 2)
        timesRight = UserDefaults.standard.object(forKey: "timesRight") as? Int ?? 0
        timesMaybe = UserDefaults.standard.object(forKey: "timesMaybe") as? Int ?? 0
        timesWrong = UserDefaults.standard.object(forKey: "timesWrong") as? Int ?? 0
    }
    
    // Reset function to set all values to default
    func resetAll() {
        dateStarted = Calendar.current.startOfDay(for: Date()).advanced(by: 86400 / 2)
        daysStudied = 0
        
        timesRight = 0
        timesMaybe = 0
        timesWrong = 0
    }
}
