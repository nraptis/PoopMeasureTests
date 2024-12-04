//
//  PathurValidator.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/4/24.
//

import Foundation
import Testing
@testable import PoopMeasure

class PathurValidator {
    
    static func validateChopperPathsInternalConsistency(chopper: StochasticSplineReducerPathChopper) -> Bool {
        
        // So, first of all, the trenches should all have either N or 0 paths...
        var trenchPathsGrid = [[[Int]]]()
        var N = 0
        for trench in chopper.trenches {
            let _allPaths = trench.convertToAllPaths()
            if _allPaths.count > 0 {
                N = _allPaths.count
                trenchPathsGrid.append(_allPaths)
            }
        }
        
        for trenchPaths in trenchPathsGrid {
            if trenchPaths.count != N {
                print("Not all paths have \(N), this path has \(trenchPaths.count)!")
                #expect(Bool(false))
                return false
            }
        }
        
        // Now, no 2 trenches should have the same path.
        // And no trench should have the same path twice.
        
        var index1 = 0
        
        while index1 < (trenchPathsGrid.count - 1) {
            
            var set1 = Set(trenchPathsGrid[index1])
            if set1.count != N {
                print("[A] As a set, count is \(set1.count) where N = \(N), implies a duplicate path!")
                #expect(Bool(false))
                return false
            }
            
            var index2 = index1 + 1
            
            while index2 < (trenchPathsGrid.count) {
                
                var set2 = Set(trenchPathsGrid[index2])
                if set2.count != N {
                    print("[B] As a set, count is \(set1.count) where N = \(N), implies a duplicate path!")
                    #expect(Bool(false))
                    return false
                }
                
                for path1 in set1 {
                    if set2.contains(path1) {
                        print("Two trenches contain the same path!")
                        print(path1)
                        #expect(Bool(false))
                        return false
                    }
                }
                
                index2 += 1
            }
            
            index1 += 1
        }
        
        
        return true
    }
    
    static func validateChopperAllPaths(chopper: StochasticSplineReducerPathChopper,
                                        paths: [[Int]]) -> Bool {
        
        var trenchPaths = [[Int]]()
        for trench in chopper.trenches {
            let _allPaths = trench.convertToAllPaths()
            trenchPaths.append(contentsOf: _allPaths)
        }
        
        let pathSetControl = Set(paths)
        let pathSetTest = Set(trenchPaths)
        
        for path in pathSetControl {
            if pathSetTest.contains(path) == false {
                print("Chopper was expected to have path, but did not!")
                print(path)
                #expect(Bool(false))
                return false
            }
        }
        
        for path in pathSetTest {
            if pathSetControl.contains(path) == false {
                print("Chopper was not expected to have path, but it did!")
                print(path)
                #expect(Bool(false))
                return false
            }
        }
        
        return true
    }
    
}
