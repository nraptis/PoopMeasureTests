//
//  TrenchValidator.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/4/24.
//

import Foundation
import Testing
@testable import PoopMeasure

class TrenchValidator {
    
    static func validateTrenchAllPaths(trench: StochasticSplineReducerPathTrench,
                                       paths: [[Int]]) -> Bool {
        
        let trenchPaths = trench.convertToAllPaths()
        
        let pathSetControl = Set(paths)
        let pathSetTest = Set(trenchPaths)
        
        for path in pathSetControl {
            if pathSetTest.contains(path) == false {
                print("Trench was expected to have path, but did not!")
                print(path)
                #expect(Bool(false))
                return false
            }
        }
        
        for path in pathSetTest {
            if pathSetControl.contains(path) == false {
                print("Trench was not expected to have path, but it did!")
                print(path)
                #expect(Bool(false))
                return false
            }
        }
        
        return true
    }
    
    static func validateTrenchAllLinksEmpty(trench: StochasticSplineReducerPathTrench) -> Bool {
        for nodeIndex in 0..<trench.nodeCount {
            let node = trench.nodes[nodeIndex]
            if node.linkCount > 0 {
                
                var links = [Int]()
                for linkIndex in 0..<node.linkCount {
                    let link = node.links[linkIndex]
                    links.append(link)
                }
                
                print("For trench, expecting empty, @\(nodeIndex)")
                print("Got Links: \(links.sorted())")
                
                #expect(Bool(false))
                return false
            }
        }
        return true
    }
    
    static func validateTrenchNodeLinks(trench: StochasticSplineReducerPathTrench,
                                 index: Int,
                                 links: [Int]) -> Bool {
        if index < 0 {
            fatalError("index < 0")
        }
        
        if index >= trench.nodeCount {
            fatalError("index >= trench.nodeCount")
        }
        
        let node = trench.nodes[index]
        
        var nodeLinkSet = Set<Int>()
        for linkIndex in 0..<node.linkCount {
            let link = node.links[linkIndex]
            nodeLinkSet.insert(link)
        }
        
        let controlLinkSet = Set(links)
        
        if controlLinkSet != nodeLinkSet {
            
            print("For trench, @ \(index).")
            print("Expected Links: \(links.sorted())")
            print("Got Links: \(Array(nodeLinkSet).sorted())")
            
            #expect(Bool(false))
            return false
        }
        
        return true
    }
    
}
