//
//  KDTree.swift
//  HueInspired
//
//  Created by Ashley Arthur on 08/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import simd

indirect enum KDNodeTree {
    
    enum Axis: Int {
        case x
        case y
        case z
    }
    
    case branch(element:vector_double3, children:(KDNodeTree, KDNodeTree))
    case leaf(element:vector_double3)
    
    init?(points:[vector_double3], maxDepth:Int = 4, depth:Int = 0){
        
        guard points.count > 0 else {
            return nil
        }
        
        let sortAxis = Axis.init(rawValue: depth % 3)!
        let sorted = points.sorted { (a,b) -> Bool in
            switch sortAxis {
            case Axis.x:
                return a.x <= b.x
            case Axis.y:
                return a.y <= b.y
            case Axis.z:
                return a.z <= b.z
            }
        }
        let medianIndex = points.count / 2
        if depth < maxDepth && sorted.count > 2 {
            self = KDNodeTree.branch(
                element: sorted[medianIndex],
                children: (
                    KDNodeTree.init(points: Array(sorted[0..<medianIndex]), maxDepth: maxDepth , depth: depth + 1)!,
                    KDNodeTree.init(points: Array(sorted[(medianIndex + 1)..<sorted.count]), maxDepth: maxDepth , depth: depth + 1)!
                )
            )
        }
        else {
            self = KDNodeTree.leaf(element: sorted[medianIndex])
        }
    }
    
    
    
}

extension KDNodeTree {
    
    func distance(_ a:vector_double3, _ b:vector_double3) -> Double{
        return distance_squared(a, b)
    }
    
    func extractElement() -> vector_double3 {
        switch self {
        case let .leaf(element):
            return element
        case let .branch(element,_):
            return element
        }
    }
    
    
    private func searchChildren(searchTerm:vector_double3, node:KDNodeTree) -> KDNodeTree? {
        
        switch node {
        case .leaf: return nil
            
        case let .branch(_, children):
            let closet = [children.0, children.1].sorted {
                self.distance($0.extractElement(), searchTerm) <= self.distance($1.extractElement(), searchTerm)
                }.first!
            return closet
        }
        
    }
    
    func searchNearest(_ element:vector_double3) -> vector_double3 {

        var currentBest: KDNodeTree = self
        var current: KDNodeTree = self
        
        while let closestChild = searchChildren(searchTerm: currentBest.extractElement(), node: current ) {
            current = closestChild
            if self.distance(closestChild.extractElement(), element) < self.distance(currentBest.extractElement(), element){
                currentBest = closestChild
            }
        }
        return currentBest.extractElement()
        
    }

}



extension KDNodeTree: Sequence {
    func makeIterator() -> KDNodeTreeIterator {
        return KDNodeTreeIterator(root: self)
    }
}


struct KDNodeTreeIterator: IteratorProtocol {
    
    private var root: KDNodeTree
    private var curentGeneration = [KDNodeTree]()
    private var currentGenerationIndex = 0
    
    init(root:KDNodeTree){
        self.root = root
        self.curentGeneration = [root]
    }
    
    func extractElement(_ n:KDNodeTree) -> vector_double3 {
        switch n {
        case let .leaf(element):
            return element
        case let .branch(element,_):
            return element
        }
    }

    mutating func next() -> vector_double3? {
        
        // Bredth first iter over graph
        
        if currentGenerationIndex < curentGeneration.count {
            defer {
                self.currentGenerationIndex += 1
            }
            return extractElement(curentGeneration[currentGenerationIndex])
        }
        
        // Generate array of next generation node to return
        else {
            let newGeneration = curentGeneration.flatMap { (node:KDNodeTree) -> [KDNodeTree]? in
                switch node {
                case .leaf:
                    return nil
                case let .branch(_, children):
                    return [children.0, children.1]
                }
            }.flatMap {
                return $0
            }
            guard newGeneration.count > 0 else {
                return nil
            }
            curentGeneration = newGeneration
            currentGenerationIndex = 1
            return extractElement(curentGeneration[0])
        }

    }
    
}
