//
//  PathValidator.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/4/24.
//

import Foundation
import Foundation
import Testing
@testable import PoopMeasure

class PathValidator {
    
    // We're assuming that "build" and "solve" were already called.
    static func validatePath(chopper: StochasticSplineReducerPathChopper,
                             pathLength: Int,
                             minimumStep: Int,
                             maximumStep: Int) -> Bool {
        
        if chopper.pathCount <= 0 {
            print("Fishy case. Path is length 0 and we're validating the path.")
            print("We should not have called solve if build failed...")
            return true
        }
        
        if chopper.path[0] >= 0 && chopper.path[0] < pathLength {
            
        } else {
            print("First node of path is out of bounds!")
            print("Path: \(pathString(chopper: chopper))")
            print("pathLength = \(pathLength)")
            print("minimumStep = \(minimumStep)")
            print("maximumStep = \(maximumStep)")
            #expect(Bool(false))
            return false
        }
        
        // So, we just want to make sure that the path follows all the rules.
        
        if chopper.pathCount == 1 {
            if pathLength >= minimumStep && pathLength <= maximumStep {
                // Fine!
            } else {
                print("One-node-path is invalid!")
                print("Path: \(pathString(chopper: chopper))")
                print("pathLength = \(pathLength)")
                print("minimumStep = \(minimumStep)")
                print("maximumStep = \(maximumStep)")
                #expect(Bool(false))
                return false
            }
        }
        
        var pathIndex = 1
        while pathIndex < chopper.pathCount {
            let previousNumber = chopper.path[pathIndex - 1]
            let currentNumber = chopper.path[pathIndex]
            if currentNumber > previousNumber {
                let delta = currentNumber - previousNumber
                if delta >= minimumStep && delta <= maximumStep {
                    // Fine!
                } else {
                    print("[A] Hop is different size than allowed!")
                    print("From \(previousNumber) to \(currentNumber)!")
                    print("Path: \(pathString(chopper: chopper))")
                    print("pathLength = \(pathLength)")
                    print("minimumStep = \(minimumStep)")
                    print("maximumStep = \(maximumStep)")
                    #expect(Bool(false))
                    return false
                }
            } else {
                let delta = (pathLength - previousNumber) + currentNumber
                if delta >= minimumStep && delta <= maximumStep {
                    // Fine!
                } else {
                    print("[A] Hop is different size than allowed!")
                    print("From \(previousNumber) to \(currentNumber)!")
                    print("Path: \(pathString(chopper: chopper))")
                    print("pathLength = \(pathLength)")
                    print("minimumStep = \(minimumStep)")
                    print("maximumStep = \(maximumStep)")
                    #expect(Bool(false))
                    return false
                }
            }
            pathIndex += 1
        }
        
        // Finally, let's make sure the last loops to first.
        let lastNumber = chopper.path[chopper.pathCount - 1]
        let firstNumber = chopper.path[0]
        if lastNumber > firstNumber {
            let delta = (pathLength - lastNumber) + firstNumber
            if delta >= minimumStep && delta <= maximumStep {
                // Fine!
            } else {
                print("[D] Hop is different size than allowed!")
                print("From \(lastNumber) to \(firstNumber)!")
                print("Path: \(pathString(chopper: chopper))")
                print("pathLength = \(pathLength)")
                print("minimumStep = \(minimumStep)")
                print("maximumStep = \(maximumStep)")
                #expect(Bool(false))
                return false
            }
        } else {
            let delta = firstNumber - lastNumber
            if delta >= minimumStep && delta <= maximumStep {
                // Fine!
            } else {
                print("[C] Hop is different size than allowed!")
                print("From \(lastNumber) to \(firstNumber)!")
                print("Path: \(pathString(chopper: chopper))")
                print("pathLength = \(pathLength)")
                print("minimumStep = \(minimumStep)")
                print("maximumStep = \(maximumStep)")
                #expect(Bool(false))
                return false
            }
        }
        return true
    }
    
    private static func pathString(chopper: StochasticSplineReducerPathChopper) -> String {
        var path = [Int]()
        for pathIndex in 0..<chopper.pathCount {
            path.append(chopper.path[pathIndex])
        }
        return "\(path)"
    }
    
}
