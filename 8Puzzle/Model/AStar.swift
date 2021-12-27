//
//  AStar.swift
//  8Puzzle
//
//  Created by Ahmed Abaza on 26/12/2021.
//

import Foundation

/// Puzzle game model.
/// - parameter heuristic: the guiding rules of our algorithm to make its decisions.
/// - parameter possiblePathes: a list of possible upcoming board states (aka pathes)
struct AStar {
    var heuristic: Int
    var possiblePathes: [Board]
}
