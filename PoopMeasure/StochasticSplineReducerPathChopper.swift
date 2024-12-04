//
//  StochasticSplineReducerPathChopper.swift
//  PoopMeasure
//
//  Created by Nicky Taylor on 12/3/24.
//

import Foundation

class StochasticSplineReducerPathChopper {

    static let maxMaximumStep = 20
    static let minMinimumStep = 2
    
    let trenches: [StochasticSplineReducerPathTrench]
    init() {
        var _trenches = [StochasticSplineReducerPathTrench]()
        _trenches.reserveCapacity(Self.maxMaximumStep)
        for index in 0..<Self.maxMaximumStep {
            _trenches.append(StochasticSplineReducerPathTrench(startIndex: index))
        }
        trenches = _trenches
    }
    
    func reset() {
        for index in 0..<Self.maxMaximumStep {
            trenches[index].reset()
        }
        
    }
    
    // Example. minimumStep = 2, maximumStep = 2
    // Input: [0, 1, 2, 3, 4, 5]
    // Output: [0, 2, 4]
    // Output: [1, 3, 5]
    
    // Example. minimumStep = 2, maximumStep = 2
    // Input: [0, 1, 2, 3, 4, 5, 6]
    // Output: Invalid.
    
    
    // Example. minimumStep = 2, maximumStep = 3
    // Input: [0, 1, 2, 3, 4, 5]
    // Output: [0, 2, 4]
    // Output: [1, 3, 5]
    
    
    
    
    
    // Example. minimumStep = 2, maximumStep = 3
    // Input: [0, 1, 2, 3, 4, 5, 6]
    
    // Output A: [0, 2, 4]
    // Output B: [0, 2, 5]
    // Output C: [0, 3, 5]
    // Output D: [1, 3, 5]
    // Output E: [1, 3, 6]
    // Output F: [1, 4, 6]
    // Output G: [2, 4, 6]
    //
    // (Note: These loop back around,
    // but for statistical reasons,
    // we should include these cases...)
    //
    // Output H: [2, 4, 0]
    // Output I: [2, 5, 0]
    
    
    // Output Starting At 0:
    
    
    
    // From 0, we can go to 2 or 3
    
    // Output 1: [0, 2, 4]
    
    
    // the assumption here is that
    // our path loops back to the start.
    // min step = 2 =>
    // [start] [e][end] [start (looping)]
    func build(pathLength: Int,
               minimumStep: Int,
               maximumStep: Int) -> Bool {
        
        if pathLength < minimumStep {
            return false
        }
        if minimumStep < StochasticSplineReducerPathChopper.minMinimumStep {
            fatalError("minimumStep < minMinimumStep")
        }
        if maximumStep > StochasticSplineReducerPathChopper.maxMaximumStep {
            fatalError("maximumStep > maxMaximumStep")
        }
        if maximumStep < minimumStep {
            fatalError("maximumStep < minimumStep")
        }
        
        // We can start anywhere from 0...(maximumStep - 1)
        for startIndex in 0..<maximumStep {
            if startIndex < pathLength {
                trenches[startIndex].reset()
                if !trenches[startIndex].build(pathLength: pathLength,
                                               minimumStep: minimumStep,
                                               maximumStep: maximumStep) {
                    return false
                }
            }
        }
        
        return true
    }
    
}
