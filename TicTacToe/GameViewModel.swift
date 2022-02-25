//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Anil Thomas on 2/24/22.
//

import SwiftUI
final class GameViewModel: ObservableObject{
    let coloums : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    
    @Published var isHuman = true
    @Published var isDisable = false
    @Published var alertItem : AlertItem?
    
  
    
    func processPlayerAndMove(in Position:Int){
        if isCircleOccupied(in: moves, at: Position){
            return
        }
        moves[Position] = Move(player: .human, index: Position)
        if isWinner(for: .human, in: moves){
            alertItem = AlertContext.humanWin
        }
        if checkDrawCondition(in: moves){
            alertItem = AlertContext.draw
        }
        isDisable = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [self] in
           
            let machinePosition = determineMachineMovePosition(in: self.moves)
            moves[machinePosition] = Move(player: .machine, index: machinePosition)
            if isWinner(for: .machine, in: self.moves){
                alertItem = AlertContext.machineWin
              
             }
            if checkDrawCondition(in: moves){
                alertItem = AlertContext.draw
            }
            isDisable = false
        }
    }
    
    
    func isCircleOccupied(in moves:[Move?],at index: Int)->Bool{
        return moves.contains(where: {$0?.index == index})
    }
    
    
    func determineMachineMovePosition(in moves: [Move?])-> Int{
        let winPattern : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]
        //if AI can win, then win
        let machineMoves = moves.compactMap{ $0 }.filter{$0.player == .machine}
        let machinePosition = Set(machineMoves.map{$0.index})
        for pattern in winPattern {
            print("position is \(pattern.subtracting(machinePosition))")
            let winPosition = pattern.subtracting(machinePosition)
            if winPosition.count == 1 {
                print("AI working")
                let isAvailable = !isCircleOccupied(in: moves, at:winPosition.first! )
                if isAvailable { return winPosition.first!}
            }
        }
       
        //if AI can't win, block
        let humanMoves = moves.compactMap{ $0 }.filter{$0.player == .human}
        let humanPosition = Set(humanMoves.map{$0.index})
        print(humanPosition)
       
        for pattern in winPattern {
            print("position is \(pattern.subtracting(humanPosition))")
            let winPosition = pattern.subtracting(humanPosition)
            if winPosition.count == 1 {
                print("AI working")
                let isAvailable = !isCircleOccupied(in: moves, at:winPosition.first! )
                if isAvailable { return winPosition.first!}
            }
          
        }
        //if can't block, take middle
        let centerPosition = 4
        let isAvailable = !isCircleOccupied(in: moves, at: centerPosition)
        if isAvailable { return centerPosition }
        
        
        //otherwise take a random position
        var position = Int.random(in: 0..<9)
        while( isCircleOccupied(in: moves, at: position)){
           position = Int.random(in: 0..<9)
        }
        return position
    }
    
    func isWinner(for player: Player,in moves: [Move?])->Bool{
        let winPattern : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.index})
        for pattern in winPattern where pattern.isSubset(of: playerPositions){
            return true
        }
            
        
        
        return false
    }
    
    
    func checkDrawCondition(in moves : [Move?])->Bool{
       return moves.compactMap{$0}.count == 9
    
}
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
    
}
