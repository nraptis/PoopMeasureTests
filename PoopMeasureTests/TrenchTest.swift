//
//  TrenchTest.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/3/24.
//

import Foundation
import Testing
@testable import PoopMeasure

struct TrenchTest {
    
    private func checkStepsPossible(exactDistance: Int,
                                    minimumStep: Int,
                                    maximumStep: Int) -> Bool {
        
        if exactDistance == 0 {
            return true
        }
        
        if exactDistance < minimumStep {
            return false
        }
        
        for step in minimumStep...maximumStep {
            if checkStepsPossible(exactDistance: exactDistance - step,
                                  minimumStep: minimumStep,
                                  maximumStep: maximumStep) {
                return true
            }
        }
        return false
    }
    
    @Test func testReachable_ManySmallRandomCases() {
        
        for _ in 0..<100_000 {
            
            let minimumStep = Int.random(in: 2...6)
            let maximumStep = Int.random(in: minimumStep...20)
            let pathLength = Int.random(in: minimumStep...32)
            
            let trenchA = StochasticSplineReducerPathTrench(startIndex: 0)
            trenchA.calculateDynamic(pathLength: pathLength,
                                     minimumStep: minimumStep,
                                     maximumStep: maximumStep)
            for _ in 0..<10 {
                
                let exactDistance = Int.random(in: 0...pathLength)
                let value = trenchA.getNumberOfStepsPossible(exactDistance: exactDistance,
                                                             minimumStep: minimumStep,
                                                             maximumStep: maximumStep)
                
                let control = checkStepsPossible(exactDistance: exactDistance,
                                                 minimumStep: minimumStep,
                                                 maximumStep: maximumStep)
                
                if value != control {
                    print("Failed! pathLength = \(pathLength)")
                    print("Failed! minimumStep = \(minimumStep)")
                    print("Failed! maximumStep = \(maximumStep)")
                    print("Failed! exactDistance = \(exactDistance)")
                    print("Failed! value = \(value)")
                    print("Failed! control = \(control)")
                    #expect(Bool(false))
                    return
                }
            }
        }
    }
    
    @Test func testReachable_SmallCases() {
        
        let trenchA = StochasticSplineReducerPathTrench(startIndex: 0)
        trenchA.calculateDynamic(pathLength: 2, minimumStep: 2, maximumStep: 2)
        if trenchA.getNumberOfStepsPossible(exactDistance: 2,
                                            minimumStep: 2,
                                            maximumStep: 2) == false {
            print("testReachable_SmallCases => Base Case 1, Fail")
            #expect(Bool(false))
            return
        }
        
        //
        let trenchB = StochasticSplineReducerPathTrench(startIndex: 0)
        trenchB.calculateDynamic(pathLength: 7, minimumStep: 3, maximumStep: 4)
        if trenchB.getNumberOfStepsPossible(exactDistance: 7,
                                            minimumStep: 3,
                                            maximumStep: 4) == false {
            print("testReachable_SmallCases => Base Case 2, Fail")
            #expect(Bool(false))
            return
        }
        
        //
        let trenchC = StochasticSplineReducerPathTrench(startIndex: 0)
        trenchC.calculateDynamic(pathLength: 7, minimumStep: 4, maximumStep: 4)
        if trenchC.getNumberOfStepsPossible(exactDistance: 7,
                                            minimumStep: 4,
                                            maximumStep: 5) == true {
            print("testReachable_SmallCases => Base Case 3, Fail")
            #expect(Bool(false))
            return
        }
    }
    
    @Test func testDistanceToStartIndexMovingForward_RandomBruteForce() {
        for _ in 0..<25000 {
            let pathLength = Int.random(in: 2...60)
            let startIndex = Int.random(in: 0..<pathLength)
            let index = Int.random(in: 0..<pathLength)
            
            let trench = StochasticSplineReducerPathTrench(startIndex: startIndex)
            let value = trench.getDistanceToStartIndexMovingForward(index: index,
                                                                    pathLength: pathLength)
            
            var control = 0
            
            var loopIndex = index
            while (loopIndex < pathLength) {
                if loopIndex == startIndex {
                    break
                }
                loopIndex += 1
                control += 1
            }
            
            if loopIndex != startIndex {
                loopIndex = 0
                while (loopIndex < pathLength) {
                    if loopIndex == startIndex {
                        break
                    }
                    loopIndex += 1
                    control += 1
                }
            }
            
            if control != value {
                print("Failed! pathLength = \(pathLength)")
                print("Failed! startIndex = \(startIndex)")
                print("Failed! index = \(index)")
                print("Failed! control = \(control)")
                print("Failed! value = \(value)")
                #expect(Bool(false))
                return
            }
        }
    }
    
    @Test func testDistanceToStartIndexMovingForward_LengthTwoCases() {
        let trench0 = StochasticSplineReducerPathTrench(startIndex: 0)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 0,
                                                             pathLength: 2) == 0)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 1,
                                                             pathLength: 2) == 1)
        
        let trench1 = StochasticSplineReducerPathTrench(startIndex: 1)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 0,
                                                             pathLength: 2) == 1)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 1,
                                                             pathLength: 2) == 0)
    }
    
    @Test func testDistanceToStartIndexMovingForward_LengthThree() {
        let trench0 = StochasticSplineReducerPathTrench(startIndex: 0)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 0,
                                                             pathLength: 3) == 0)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 1,
                                                             pathLength: 3) == 2)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 2,
                                                             pathLength: 3) == 1)
        
        let trench1 = StochasticSplineReducerPathTrench(startIndex: 1)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 0,
                                                             pathLength: 3) == 1)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 1,
                                                             pathLength: 3) == 0)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 2,
                                                             pathLength: 3) == 2)
        
        let trench2 = StochasticSplineReducerPathTrench(startIndex: 2)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 0,
                                                             pathLength: 3) == 2)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 1,
                                                             pathLength: 3) == 1)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 2,
                                                             pathLength: 3) == 0)
    }
    
    @Test func testDistanceToStartIndexMovingForward_LengthFour() {
        let trench0 = StochasticSplineReducerPathTrench(startIndex: 0)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 0,
                                                            pathLength: 4) == 0)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 1,
                                                            pathLength: 4) == 3)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 2,
                                                            pathLength: 4) == 2)
        #expect(trench0.getDistanceToStartIndexMovingForward(index: 3,
                                                            pathLength: 4) == 1)
        
        let trench1 = StochasticSplineReducerPathTrench(startIndex: 1)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 0,
                                                            pathLength: 4) == 1)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 1,
                                                            pathLength: 4) == 0)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 2,
                                                            pathLength: 4) == 3)
        #expect(trench1.getDistanceToStartIndexMovingForward(index: 3,
                                                            pathLength: 4) == 2)
        
        let trench2 = StochasticSplineReducerPathTrench(startIndex: 2)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 0,
                                                            pathLength: 4) == 2)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 1,
                                                            pathLength: 4) == 1)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 2,
                                                            pathLength: 4) == 0)
        #expect(trench2.getDistanceToStartIndexMovingForward(index: 3,
                                                            pathLength: 4) == 3)
        
        let trench3 = StochasticSplineReducerPathTrench(startIndex: 3)
        #expect(trench3.getDistanceToStartIndexMovingForward(index: 0,
                                                            pathLength: 4) == 3)
        #expect(trench3.getDistanceToStartIndexMovingForward(index: 1,
                                                            pathLength: 4) == 2)
        #expect(trench3.getDistanceToStartIndexMovingForward(index: 2,
                                                            pathLength: 4) == 1)
        #expect(trench3.getDistanceToStartIndexMovingForward(index: 3,
                                                            pathLength: 4) == 0)
    }
    
}
