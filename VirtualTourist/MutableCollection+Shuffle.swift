//
//  MutableCollection+Shuffle.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/29/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import Foundation

// MARK: - MutableCollection

extension MutableCollection where Indices.Iterator.Element == Index {
    
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
    
}

// MARK: - Sequence

extension Sequence {
    
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        
        var result = Array(self)
        result.shuffle()
        return result
    }
    
}
