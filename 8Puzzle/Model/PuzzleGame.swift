//
//  PuzzleGame.swift
//  8Puzzle
//
//  Created by Ahmed Abaza on 26/12/2021.
//

import Foundation

class PuzzleGame {
    
    //MARK: -Properties
    private(set) var boardState: Board!
    
    /// The correctly positioned elements on the board.
    private let correctBoardState = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0]
    ]
    
    
    //MARK: -Computed Properties
    private var availableMoves: Int {
        return generatePossiblePathes(from: boardState).count
    }
    
    
    
    //MARK: -Initializers
    init(for board: Board) {
        self.boardState = board
    }
    
    
    
    
    //MARK: -Functions
    private func generatePossiblePathes(from currentState: Board) -> [Board] {
        var possibleStates: [Board] = []
        
        /*
         Approach:
         - find the empty square coordinates, row and column. If it doesn't exist we make an early return
         (the empty square in our data representation is the array element 0)
         - decide a movement direction for the empty square based on its position in the current state passed in to the function
         (kinda counter intuitive or mind bending as we expect to be moving the non empty.
          Also, we're actually not moving rather than just swapping.)
         - add all possible movement directions to the possible states array
         */
        
        guard let rowIndexOfTheEmptySquare = currentState.firstIndex(where: { $0.contains(0)}),
              let columnIndexOfTheEmptySquare = currentState[rowIndexOfTheEmptySquare].firstIndex(of: 0)
        else {return possibleStates}
        
        /*
         Row Cases:
         - the empty square is not in the first row, aka the row index > 0 (we can move it up)
         - the empty square is not in the last row, aka the row index < (count - 1) (we can move it down)
         Column Cases:
         - the empty square is not in the first column, aka the column index > 0 (we can move it right)
         - the empty square is not in the last column, aka the coumn index < (count - 1) (we can move it left)
         */
        
        if rowIndexOfTheEmptySquare > 0 {
            // move it up
            let possibleState = self.moveSquare(
                inPosition: (row: rowIndexOfTheEmptySquare, col: columnIndexOfTheEmptySquare),
                from: currentState,
                direction: .Up
            )
            //append to the possible states
            possibleStates.append(possibleState)
        }
        
        if rowIndexOfTheEmptySquare < (currentState.count - 1) {
            // move it down
            let possibleState = self.moveSquare(
                inPosition: (row: rowIndexOfTheEmptySquare, col: columnIndexOfTheEmptySquare),
                from: currentState,
                direction: .Down
            )
            //append to the possible states
            possibleStates.append(possibleState)
        }
        
        
        if columnIndexOfTheEmptySquare > 0 {
            // move it left
            let possibleState = self.moveSquare(
                inPosition: (row: rowIndexOfTheEmptySquare, col: columnIndexOfTheEmptySquare),
                from: currentState,
                direction: .Left
            )
            //append to the possible states
            possibleStates.append(possibleState)
        }
        
        if rowIndexOfTheEmptySquare < (currentState.count - 1) {
            // move it right
            let possibleState = self.moveSquare(
                inPosition: (row: rowIndexOfTheEmptySquare, col: columnIndexOfTheEmptySquare),
                from: currentState,
                direction: .Right
            )
            //append to the possible states
            possibleStates.append(possibleState)
        }
        
        
        return possibleStates
    }
    
    ///- Description: memics the act of movement by swapping the element in the position specified with the upfronting element in the direction specified.
    ///
    /// - parameter inPosition: tuple of element position (row, col)
    /// - parameter from: the board state to be changed.
    /// - parameter movementDirection: the movement direction in which the element to be moved.
    private func moveSquare(inPosition position:(row: Int, col: Int), from currentBoardState: Board, direction movementDirection: MovementDirection) -> Board {
        var manipulationBoard = currentBoardState
        
        switch movementDirection {
        case .Up:
            manipulationBoard.swapAt(position.row, position.row - 1)
            return manipulationBoard
        case .Down:
            manipulationBoard.swapAt(position.row, position.row + 1)
            return manipulationBoard
        case .Left:
            manipulationBoard[position.row].swapAt(position.col, position.col - 1)
            return manipulationBoard
        case .Right:
            manipulationBoard[position.row].swapAt(position.col, position.col + 1)
            return manipulationBoard
        }
    }
    
    /// Count of the wrongly posined elements on the board state passed
    ///  - returns Integer count of the elements wrongly positioned.
    private func countOfWronglyPositionedElementsOnBoard(_ board: Board) -> Int {
        guard board.count == self.correctBoardState.count else {return 0}
        
        //Count of the wrongly posined elements on the board state passed
        var count = 0
        
        for row in 0 ..< board.count {
            for col in 0 ..< board[row].count {
                count += board[row][col] != self.correctBoardState[row][col] ? 1 : 0
            }
        }
        
        return count
    }
    
    private func aStarPathFinder(for board: Board) -> AStar {
        var exploredPathes: [Board] = []
        var pathesList = [AStar(heuristic: countOfWronglyPositionedElementsOnBoard(board), possiblePathes: [board])]
        var path = AStar(heuristic: 1, possiblePathes: [])
        
        
        while true {
            let bestHeuristicIndex = pathesList.indices.reduce(0) {
                pathesList[$1].heuristic < pathesList[$0].heuristic ? $1 : $0
            }
            
            path = pathesList.remove(at: bestHeuristicIndex)
            
            let finalStateBoardFromBestHeuristic = path.possiblePathes.last!
            
            if exploredPathes.contains(finalStateBoardFromBestHeuristic) { continue }
            
            for state in generatePossiblePathes(from: finalStateBoardFromBestHeuristic) {
                if exploredPathes.contains(state) { continue }
                let heuristic = path.heuristic + countOfWronglyPositionedElementsOnBoard(state) + countOfWronglyPositionedElementsOnBoard(finalStateBoardFromBestHeuristic)
                let new = path.possiblePathes + [state]
                pathesList.append(AStar(heuristic: heuristic, possiblePathes: new))
            }
            
            exploredPathes.append(finalStateBoardFromBestHeuristic)
            
            if finalStateBoardFromBestHeuristic == self.correctBoardState {
                break
            }
        }
        
        return path
    }
    
    
    func solve() -> [Board] {
        return self.aStarPathFinder(for: self.boardState).possiblePathes
    }
    
}




//MARK: -Alias

/// An alias of the 2D array representing the board.
typealias Board = [[Int]]

