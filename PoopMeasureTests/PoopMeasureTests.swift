//
//  PoopMeasureTests.swift
//  PoopMeasureTests
//
//  Created by Nicky Taylor on 12/3/24.
//

import Testing
@testable import PoopMeasure

struct PoopMeasureTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func testPoolSmall() {
        
        let list1 = [1, 2, 3]
        let list2 = [0, 2, 3]
        let list3 = [1, 1, 2, 3]
        
        let negative1 = [1, 2, 3, 3]
        let negative2 = [0]
        let negative3 = [1, 1, 2]
        
        let pool = StochasticSplineReducerExploredPool()
        
        pool.ingest(list: list1)
        pool.ingest(list: list2)
        pool.ingest(list: list3)
        
        if pool.contains(list: negative1) {
            print("pool contained negative1: \(negative1)")
            #expect(Bool(false))
        }
        if pool.contains(list: negative2) {
            print("pool contained negative2: \(negative2)")
            #expect(Bool(false))
        }
        if pool.contains(list: negative3) {
            print("pool contained negative3: \(negative3)")
            #expect(Bool(false))
        }
        
        if !pool.contains(list: list1) {
            print("pool didn't contain list1: \(list1)")
            #expect(Bool(false))
        }
        
        if !pool.contains(list: list2) {
            print("pool didn't contain list2: \(list2)")
            #expect(Bool(false))
        }
        
        if !pool.contains(list: list3) {
            print("pool didn't contain list3: \(list3)")
            #expect(Bool(false))
        }
    }

    func generateNumberListA(count: Int) -> [Int] {
        var result = [Int]()
        var index = 0
        while index < count {
            let number = Int.random(in: -50...50)
            result.append(number)
            index += 1
        }
        return result
    }
    
    func generateNumberListB(count: Int) -> [Int] {
        var result = [Int]()
        var index = 0
        while index < count {
            let number = Int.random(in: 0...10)
            result.append(number)
            index += 1
        }
        return result
    }
    
    @Test func testPoolMany() {
        for _ in 0..<12_500 {
            let pool = StochasticSplineReducerExploredPool()
            let numberOfLists = Int.random(in: 1...40)
            var lists = [[Int]]()
            var control = Set<[Int]>()
            for _ in 0..<numberOfLists {
                if Bool.random() {
                    let list = generateNumberListA(count: Int.random(in: 0...100))
                    lists.append(list)
                } else {
                    let list = generateNumberListB(count: Int.random(in: 0...100))
                    lists.append(list)
                }
            }
            
            for list in lists {
                if Bool.random() {
                    pool.ingest(list: list)
                    control.insert(list)
                }
            }
            
            for list in lists {
                if control.contains(list) != pool.contains(list: list) {
                    print("Failed for this list: \(list)")
                    #expect(Bool(false))
                }
            }
        }
    }
    
    @Test func testBigger() {
        for _ in 0..<12_500 {
            let pool = StochasticSplineReducerExploredPool()
            let numberOfLists = Int.random(in: 20...100)
            var lists = [[Int]]()
            var control = Set<[Int]>()
            for _ in 0..<numberOfLists {
                if Bool.random() {
                    let list = generateNumberListA(count: Int.random(in: 25...300))
                    lists.append(list)
                } else {
                    let list = generateNumberListB(count: Int.random(in: 25...300))
                    lists.append(list)
                }
            }
            
            for list in lists {
                if Bool.random() {
                    pool.ingest(list: list)
                    control.insert(list)
                }
            }
            
            for list in lists {
                if control.contains(list) != pool.contains(list: list) {
                    print("Failed for this list: \(list)")
                    #expect(Bool(false))
                }
            }
        }
    }
    
}
