//
//  GameView.swift
//  TicTacToe
//
//  Created by Anil Thomas on 2/23/22.
//

import SwiftUI




struct GameView: View {
    
    @StateObject private var vm = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: vm.coloums,spacing: 15){
                ForEach(0..<9){i in
                    ZStack{
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: geometry.size.width/3-10, height: geometry.size.width/3-10, alignment: .center)
                        Image(systemName: vm.moves[i]?.indicator ?? "")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    .onTapGesture {
                        vm.processPlayerAndMove(in: i)
                       
                    }
                }
            }
                Spacer()
            }.padding()
                .disabled(vm.isDisable)
                .alert(item: $vm.alertItem, content: { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: { vm.resetGame() }))
                     
                    
                })
        }
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


