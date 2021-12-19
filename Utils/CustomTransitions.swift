//
//  CustomTransitions.swift
//  GermanLearning
//
//  Created by Niklas on 19/07/2021.
//  This is a helper file that defines some extensions to the SwiftUI transition class for custom transitions

import Foundation
import SwiftUI


extension AnyTransition {
    // Rise and fade -> come up from button and fade in
    static var riseAndFade: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(
            with: AnyTransition.opacity
        )
    }
    
    // Fall with fade -> come in from top edge with fade
    static var topEdgeWithFade: AnyTransition {
        AnyTransition.move(edge: .top).combined(
            with: AnyTransition.opacity
        )
    }
    
    // Delayed drop and fade -> fall down after a few seconds
    static var delayedDropAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: AnyTransition.riseAndFade.animation(
                Animation.default.delay(0.2)
            ),
            removal: AnyTransition.identity
        )
    }
}
