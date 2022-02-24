//
//  ContentView.swift
//  TicTacToe
//
//  Created by Anil Thomas on 2/23/22.
//

import SwiftUI



struct ContentView: View {
    let coloums : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    @SwiftUI.State private var moves : [Move?] = Array(repeating: nil, count: 9)
    
    @SwiftUI.State private var isHuman = true
    
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
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                            let machinePosition = determineMachineMovePosition(in: moves)
                            moves[machinePosition] = Move(player: .machine, index: machinePosition)
                        }
                       
                    }
                }

                
            }
                Spacer()
            
            }.padding()
        }
    }
    
    func isCircleOccupied(in moves:[Move?],at index: Int)->Bool{
        return moves.contains(where: {$0?.index == index})
    }
    
    
    func determineMachineMovePosition(in moves: [Move?])-> Int{
        var position = Int.random(in: 0..<9)
        while( isCircleOccupied(in: moves, at: position)){
           position = Int.random(in: 0..<9)
        }
        return position
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
        ContentView()
    }
}


