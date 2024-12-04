//
//  PathurTest.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/3/24.
//

import Foundation
import Testing
@testable import PoopMeasure

struct PathurTest {
    
    
    
    @Test func testManualCaseD() {
        
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
        
        let chopper = StochasticSplineReducerPathChopper()
        let trench0 = chopper.trenches[0]
        let trench1 = chopper.trenches[1]
        let trench2 = chopper.trenches[2]
        
        _ = chopper.build(pathLength: 7,
                          minimumStep: 2,
                          maximumStep: 3)
        
        // Output A: [0, 2, 4]
        // Output B: [0, 2, 5]
        // Output C: [0, 3, 5]
        if !TrenchValidator.validateTrenchAllPaths(trench: trench0,
                                                   paths: [[0, 2, 4], [0, 2, 5], [0, 3, 5]]) {
            #expect(Bool(false))
            return
        }
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench1,
                                                   paths: [[1, 3, 5], [1, 3, 6], [1, 4, 6]]) {
            #expect(Bool(false))
            return
        }
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench2,
                                                   paths: [[2, 4, 6], [2, 4, 0], [2, 5, 0]]) {
            #expect(Bool(false))
            return
        }
    }
    
    @Test func testManualCaseC() {
        
        // Example. minimumStep = 2, maximumStep = 3
        // Input: [0, 1, 2, 3, 4, 5]
        // Output: [0, 2, 4]
        // Output: [0, 3]
        // Output: [1, 3, 5]
        // Output: [1, 4]
        
        let chopper = StochasticSplineReducerPathChopper()
        let trench0 = chopper.trenches[0]
        let trench1 = chopper.trenches[1]
        
        _ = chopper.build(pathLength: 6,
                          minimumStep: 2,
                          maximumStep: 3)
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench0,
                                                   paths: [[0, 2, 4], [0, 3]]) {
            #expect(Bool(false))
            return
        }
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench1,
                                                   paths: [[1, 3, 5], [1, 4]]) {
            #expect(Bool(false))
            return
        }
    }
    
    
    @Test func testManualCaseB() {
        
        // Example. minimumStep = 2, maximumStep = 2
        // Input: [0, 1, 2, 3, 4, 5, 6]
        // Output: Invalid.
        
        let chopper = StochasticSplineReducerPathChopper()
        if chopper.build(pathLength: 7,
                         minimumStep: 2,
                         maximumStep: 2) {
            
            print("Expected invalid (pathLength = 7) (minimumStep = 2) (maximumStep = 2)")
            
            #expect(Bool(false))
            return
        }
    }
    
    @Test func testManualCaseA() {
        
        // Example. minimumStep = 2, maximumStep = 2
        // Input: [0, 1, 2, 3, 4, 5]
        // Output: [0, 2, 4]
        // Output: [1, 3, 5]
        
        let chopper = StochasticSplineReducerPathChopper()
        let trench0 = chopper.trenches[0]
        let trench1 = chopper.trenches[1]
        
        _ = chopper.build(pathLength: 6,
                          minimumStep: 2,
                          maximumStep: 2)
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench0,
                                                   paths: [[0, 2, 4]]) {
            #expect(Bool(false))
            return
        }
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench1,
                                                   paths: [[1, 3, 5]]) {
            #expect(Bool(false))
            return
        }
    }
    
}
