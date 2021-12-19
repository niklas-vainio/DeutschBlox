//
//  SpaceRepetitionManager.swift
//  GermanLearning
//
//  Created by Niklas on 22/07/2021.
//  This file defines a struct with static methods to compute spaced repetition intervals

import Foundation

struct SpaceRepetitionManager {
    
    // Calculate next interval and ease factor given current SRSData object and button press
    static func getNextnterval(for srsData: SRSData, after buttonPress: UnderstandingButtonType) -> (nextInterval: Double, nextEaseFactor: Double) {
        
        // Calculate next ease factor based on which button was pressed
        var nextEaseFactor: Double = srsData.easeFactor
        switch buttonPress {
        case .tick:
            nextEaseFactor += 0.2
        case .questionMark:
            nextEaseFactor += 0.0
        case .cross:
            nextEaseFactor -= 0.4
        }
        
        nextEaseFactor = min(nextEaseFactor, 3.0)
        nextEaseFactor = max(nextEaseFactor, 1.0)
        
        // Multiply current interval by new ease factor and constrain to be less than a week
        // Add random variation of ± 10%
        let nextInterval: Double = min(srsData.lastInterval * nextEaseFactor * Double.random(in: 0.9...1.1),
                                       7.0 * 86400.0)
        
        // Return new ease factor and interval
        return (nextInterval, nextEaseFactor)
    }
}


