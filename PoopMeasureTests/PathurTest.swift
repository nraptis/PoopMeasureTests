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
    
    @Test func testManualCaseC() {
        
        // Example. minimumStep = 2, maximumStep = 3
        // Input: [0, 1, 2, 3, 4, 5]
        // Output: [0, 2, 4]
        // Output: [0, 3]
        // Output: [1, 3, 5]
        // Output: [1, 4]
        // Output: [2, 4, 0]
        // Output: [2, 5]
        
        let chopper = StochasticSplineReducerPathChopper()
        let trench0 = chopper.trenches[0]
        let trench1 = chopper.trenches[1]
        let trench2 = chopper.trenches[2]
        
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
        
        if !TrenchValidator.validateTrenchAllPaths(trench: trench2,
                                                   paths: [[2, 4, 0], [2, 5]]) {
            #expect(Bool(false))
            return
        }
    }
    
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
    
    @Test func testManySmallChoppers() {
        
        for test_loop in 0..<300000 {
            
            if (test_loop % 10_000) == 0 {
                print("@@testManySmallTrials #\(test_loop)")
            }
            
            let minimumStep = Int.random(in: 2...4)
            let maximumStep = Int.random(in: minimumStep...6)
            let pathLength = Int.random(in: minimumStep...12)
            
            let controlAllPaths = computeAllPaths(pathLength: pathLength,
                                                  minimumStep: minimumStep,
                                                  maximumStep: maximumStep)
            
            let chopper = StochasticSplineReducerPathChopper()
            
            if chopper.build(pathLength: pathLength,
                             minimumStep: minimumStep,
                             maximumStep: maximumStep) {
                
                if !PathurValidator.validateChopperAllPaths(chopper: chopper,
                                                            paths: controlAllPaths) {
                    #expect(Bool(false))
                    return
                }
            } else {
                if controlAllPaths.count > 0 {
                    print("Expected more paths!")
                    print("\(controlAllPaths[0]) for example.")
                    print("We got 0 paths...")
                    #expect(Bool(false))
                    return
                }
            }

            if !PathurValidator.validateChopperPathsInternalConsistency(chopper: chopper) {
                #expect(Bool(false))
                return
            }
        }
    }
    
    @Test func testExceedingNumberOfTrials() {
        
        for test_loop in 0..<300000 {
            
            if (test_loop % 10_000) == 0 {
                print("@@testExceedingNumberOfTrials #\(test_loop)")
            }
            
            
            let minimumStep = Int.random(in: 2...8)
            let maximumStep = Int.random(in: minimumStep...14)
            let pathLength = Int.random(in: minimumStep...20)
            
            let controlAllPaths = computeAllPaths(pathLength: pathLength,
                                                  minimumStep: minimumStep,
                                                  maximumStep: maximumStep)
            
            let chopper = StochasticSplineReducerPathChopper()
            
            if chopper.build(pathLength: pathLength,
                             minimumStep: minimumStep,
                             maximumStep: maximumStep) {
                
                if !PathurValidator.validateChopperAllPaths(chopper: chopper,
                                                            paths: controlAllPaths) {
                    #expect(Bool(false))
                    return
                }
            } else {
                if controlAllPaths.count > 0 {
                    print("Expected more paths!")
                    print("\(controlAllPaths[0]) for example.")
                    print("We got 0 paths...")
                    #expect(Bool(false))
                    return
                }
            }

            if !PathurValidator.validateChopperPathsInternalConsistency(chopper: chopper) {
                #expect(Bool(false))
                return
            }
        }
    }
    
    func computeAllPaths(pathLength: Int,
                         minimumStep: Int,
                         maximumStep: Int) -> [[Int]] {
        var result = [[Int]]()
        for startIndex in 0..<maximumStep {
            if startIndex < pathLength {
                var temp = [Int]()
                computeAllPathsHelper(index: startIndex,
                                      distanceWalked: 0,
                                      callDepth: 0,
                                      startIndex: startIndex,
                                      pathLength: pathLength,
                                      minimumStep: minimumStep,
                                      maximumStep: maximumStep,
                                      temp: &temp,
                                      result: &result)
            }
        }
        return result
    }
    
    func computeAllPathsHelper(index: Int,
                               distanceWalked: Int,
                               callDepth: Int,
                               startIndex: Int,
                               pathLength: Int,
                               minimumStep: Int,
                               maximumStep: Int,
                               temp: inout [Int],
                               result: inout [[Int]]) {
        
        if index == startIndex && callDepth > 0 {
            result.append(temp)
            return
        }
        if distanceWalked >= pathLength {
            return
        }
        
        for step in minimumStep...maximumStep {
            if step < pathLength {
                
                var nextIndex = index + step
                if nextIndex >= pathLength {
                    nextIndex -= pathLength
                    if nextIndex > startIndex {
                        // in this case, we went back past start...
                        return
                    }
                }
                temp.append(index)
                computeAllPathsHelper(index: nextIndex,
                                      distanceWalked: distanceWalked + step,
                                      callDepth: callDepth + 1,
                                      startIndex: startIndex,
                                      pathLength: pathLength,
                                      minimumStep: minimumStep,
                                      maximumStep: maximumStep,
                                      temp: &temp,
                                      result: &result)
                _ = temp.popLast()
            }
        }
    }
}
