//
//  GameView.swift
//  TicTacToe
//
//  Created by Anil Thomas on 2/23/22.
//

import SwiftUI




struct GameView: View {
    let coloums : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    @SwiftUI.State private var moves : [Move?] = Array(repeating: nil, count: 9)
    
    @SwiftUI.State private var isHuman = true
    @SwiftUI.State private var isDisable = false
    @SwiftUI.State private var alertItem : AlertItem?
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
            LazyVGrid(columns: coloums,spacing: 15){
                ForEach(0..<9){i in
                    ZStack{
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: geometry.size.width/3-10, height: geometry.size.width/3-10, alignment: .center)
                        Image(systemName: moves[i]?.indicator ?? "")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    .onTapGesture {
                        
                        if isCircleOccupied(in: moves, at: i){
                            return
                        }
                        moves[i] = Move(player: .human, index: i)
                       if isWinner(for: .human, in: moves){
                           alertItem = AlertContext.humanWin
                        }
                        if checkDrawCondition(in: moves){
                            alertItem = AlertContext.draw
                        }
                        isDisable = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                           
                            let machinePosition = determineMachineMovePosition(in: moves)
                            moves[machinePosition] = Move(player: .machine, index: machinePosition)
                            if isWinner(for: .machine, in: moves){
                                alertItem = AlertContext.machineWin
                              
                             }
                            if checkDrawCondition(in: moves){
                                alertItem = AlertContext.draw
                            }
                            isDisable = false
                        }
                    }
                }
            }
                Spacer()
            }.padding()
                .disabled(isDisable)
                .alert(item: $alertItem, content: { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
                     
                    
                })
        }
    }
    
    func isCircleOccupied(in moves:[Move?],at index: Int)->Bool{
        return moves.contains(where: {$0?.index == index})
    }
    
    
    func determineMachineMovePosition(in moves: [Move?])-> Int{
        
       
       
        var winPattern : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]
        //if AI can win, then win
        let machineMoves = moves.compactMap{ $0 }.filter{$0.player == .machine}
        let machinePosition = Set(machineMoves.map{$0.index})
        print(machinePosition)
       
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
        var winPattern : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]
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



enum Player {
    case human, machine
}

struct Move{
    var player : Player
    var index : Int
    var indicator : String {
        return player == .human ? "xmark" : "circle"
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}


