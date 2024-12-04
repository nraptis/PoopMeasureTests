//
//  PathTest.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/4/24.
//

import Foundation
import Testing
@testable import PoopMeasure

struct PathTest {
    
    @Test func testManualCaseA() {
        
        // Example. minimumStep = 2, maximumStep = 2
        // Input: [0, 1, 2, 3, 4, 5]
        // Output: [0, 2, 4]
        // Output: [1, 3, 5]
        
        for _ in 0..<100 {
            let chopper = StochasticSplineReducerPathChopper()
            _ = chopper.build(pathLength: 6,
                              minimumStep: 2,
                              maximumStep: 2)
            
            chopper.solve()
            
            var path = [Int]()
            for pathIndex in 0..<chopper.pathCount {
                path.append(chopper.path[pathIndex])
            }
            
            if chopper.pathCount != 3 {
                print("Expected exactly a length of 3!")
                #expect(Bool(false))
                return
            }
            
            if path == [0, 2, 4] || path == [1, 3, 5] {
                // This is good.
            } else {
                print("Expected [0, 2, 4] or [1, 3, 5]!")
                print("Got: \(path)")
                #expect(Bool(false))
                return
            }
        }
    }
    
    @Test func testManualCaseB() {
        
        // Example. minimumStep = 2, maximumStep = 2
        // Input: [0, 1, 2, 3, 4, 5, 6]
        // Output: Invalid.
        
        for _ in 0..<100 {
            let chopper = StochasticSplineReducerPathChopper()
            _ = chopper.build(pathLength: 7,
                              minimumStep: 2,
                              maximumStep: 2)
            chopper.solve()
            
            var path = [Int]()
            for pathIndex in 0..<chopper.pathCount {
                path.append(chopper.path[pathIndex])
            }
            
            if chopper.pathCount != 0 {
                print("Expected exactly a length of 0!")
                #expect(Bool(false))
                return
            }
            
            if path == [] {
                // This is good.
            } else {
                print("Expected []!")
                print("Got: \(path)")
                #expect(Bool(false))
                return
            }
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
        
        for _ in 0..<100 {
            let chopper = StochasticSplineReducerPathChopper()
            
            _ = chopper.build(pathLength: 6,
                              minimumStep: 2,
                              maximumStep: 3)
            
            chopper.solve()
            
            var path = [Int]()
            for pathIndex in 0..<chopper.pathCount {
                path.append(chopper.path[pathIndex])
            }
            
            if path == [0, 2, 4] ||
                path == [0, 3] ||
                path == [1, 3, 5] ||
                path == [1, 4] ||
                path == [2, 4, 0] ||
                path == [2, 5] {
                // This is good.
            } else {
                print("Expected [0, 2, 4] or [0, 3] or [1, 3, 5] or [1, 4] or [2, 4, 0] or [2, 5]!")
                print("Got: \(path)")
                #expect(Bool(false))
                return
            }
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
        
        for _ in 0..<100 {
            
            let chopper = StochasticSplineReducerPathChopper()
            _ = chopper.build(pathLength: 7,
                              minimumStep: 2,
                              maximumStep: 3)
            
            chopper.solve()
            
            var path = [Int]()
            for pathIndex in 0..<chopper.pathCount {
                path.append(chopper.path[pathIndex])
            }
            
            if path == [0, 2, 4] ||
                path == [0, 2, 5] ||
                path == [0, 3, 5] ||
                path == [1, 3, 5] ||
                path == [1, 3, 6] ||
                path == [1, 4, 6] ||
                path == [2, 4, 6] ||
                path == [2, 4, 0] ||
                path == [2, 5, 0] {
                // This is good.
            } else {
                print("Expected [0, 2, 4] or [0, 2, 5] or [0, 3, 5] or [1, 3, 5] or [1, 3, 6] or [1, 4, 6] or [2, 4, 6] or [2, 4, 0] or [2, 5, 0]!")
                print("Got: \(path)")
                #expect(Bool(false))
                return
            }
        }
    }
    
    @Test func testManySmallPaths() {
        
        for test_loop in 0..<30000 {
            
            if (test_loop % 10_000) == 0 {
                print("@@testManySmallTrials #\(test_loop)")
            }
            
            let minimumStep = Int.random(in: 2...4)
            let maximumStep = Int.random(in: minimumStep...6)
            let pathLength = Int.random(in: minimumStep...12)
            
            let chopper = StochasticSplineReducerPathChopper()
            
            if chopper.build(pathLength: pathLength,
                             minimumStep: minimumStep,
                             maximumStep: maximumStep) {
                chopper.solve()
                if !PathValidator.validatePath(chopper: chopper,
                                               pathLength: pathLength,
                                               minimumStep: minimumStep,
                                               maximumStep: maximumStep) {
                    #expect(Bool(false))
                    return
                }
            } else {
                chopper.solve()
                if chopper.pathCount != 0 {
                    print("Expected pathCount to be 0!")
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
            
            let chopper = StochasticSplineReducerPathChopper()
            
            if chopper.build(pathLength: pathLength,
                             minimumStep: minimumStep,
                             maximumStep: maximumStep) {
                chopper.solve()
                if !PathValidator.validatePath(chopper: chopper,
                                               pathLength: pathLength,
                                               minimumStep: minimumStep,
                                               maximumStep: maximumStep) {
                    #expect(Bool(false))
                    return
                }
            } else {
                chopper.solve()
                if chopper.pathCount != 0 {
                    print("Expected pathCount to be 0!")
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
}
